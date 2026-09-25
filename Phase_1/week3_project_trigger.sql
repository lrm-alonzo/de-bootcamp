--TRIGGER

--> TABLE: ORDERS
-- 1. Automatically calculate total_amount based on order_items when a new order is created or updated

CREATE OR REPLACE FUNCTION update_order_total()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate the total of all order_items for this order_id
    UPDATE orders
    SET total_amount = (
        SELECT COALESCE(SUM(quantity * unit_price), 0)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop TRIGGER IF EXISTS trg_update_order_total ON order_items;

CREATE TRIGGER trg_update_order_total
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_order_total();

----------------------------------------------------------------------------------------------------------------------

--> TABLE: INVENTORY
-- 1. Automatically update inventory quantity when an order is placed
-- ALSO ADDED RAISE ERROR ONCE THE PRODUCT_ID AND STORE_ID COMBINATION IS NOT FOUND IN THE INVENTORY TABLE
CREATE OR REPLACE FUNCTION update_inventory()
RETURNS TRIGGER AS $$
DECLARE
    store INT;
BEGIN
    -- Get store_id from orders
    SELECT store_id INTO store
    FROM orders
    WHERE order_id = NEW.order_id;

    -- Try to update inventory
    UPDATE inventory
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id
      AND store_id = store;

    -- If no row was updated, raise an error
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No inventory record found for product_id % and store_id %',
            NEW.product_id, store;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_inventory ON order_items;

CREATE TRIGGER trg_update_inventory
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_inventory();


-- 2. Automatically update reorder_flag based on quantity (e.g., if quantity < threshold, set reorder_flag to TRUE)
-- 3. Automatically update last_updated timestamp whenever the quantity is updated
-- Function: refresh metadata (last_updated + reorder_flag) whenever inventory changes
CREATE OR REPLACE FUNCTION refresh_inventory_metadata()
RETURNS TRIGGER AS $$
DECLARE
    threshold INT := 10;
BEGIN
    NEW.last_updated := CURRENT_TIMESTAMP;

    IF NEW.quantity < threshold THEN
        NEW.reorder_flag := TRUE;
    ELSE
        NEW.reorder_flag := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_refresh_inventory_metadata ON inventory;

CREATE TRIGGER trg_refresh_inventory_metadata
BEFORE INSERT OR UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION refresh_inventory_metadata();
----------------------------------------------------------------------------------------------------------------------
--> TABLE: INVOICES
-- 1. Set due date 30 days after issue date
CREATE OR REPLACE FUNCTION set_due_date()
RETURNS TRIGGER AS $$
BEGIN
    NEW.due_date := NEW.issue_date + INTERVAL '30 days';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_set_due_date ON invoices;

CREATE TRIGGER trg_set_due_date
BEFORE INSERT ON invoices
FOR EACH ROW
EXECUTE FUNCTION set_due_date();

--2. Automatically update status (Paid, Partially paid)
CREATE OR REPLACE FUNCTION update_invoice_status_on_payment()
RETURNS TRIGGER AS $$
DECLARE
    total_paid DECIMAL(10,2);
    invoice_total DECIMAL(10,2);
BEGIN
    -- Sum of all payments for this invoice
    SELECT COALESCE(SUM(amount),0) INTO total_paid
    FROM payments
    WHERE invoice_id = NEW.invoice_id;

    -- Get invoice total from orders (assuming orders table has total_amount)
    SELECT total_amount INTO invoice_total
    FROM orders
    WHERE order_id = NEW.order_id;

    -- Update invoice status
    IF total_paid >= invoice_total THEN
        UPDATE invoices
        SET status = 'Paid'
        WHERE invoice_id = NEW.invoice_id;
    ELSIF total_paid > 0 AND total_paid < invoice_total THEN
        UPDATE invoices
        SET status = 'Partially paid'
        WHERE invoice_id = NEW.invoice_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_invoice_status_on_payment ON payments;

CREATE TRIGGER trg_update_invoice_status_on_payment
AFTER INSERT OR UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION update_invoice_status_on_payment();

--3. Automatically update status to 'Overdue' if due date has passed and status is still 'Pending'
CREATE OR REPLACE FUNCTION mark_overdue_invoices()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Pending' AND NEW.due_date < CURRENT_TIMESTAMP THEN
        NEW.status := 'Overdue';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_mark_overdue_invoices ON invoices;

CREATE TRIGGER trg_mark_overdue_invoices
BEFORE UPDATE ON invoices
FOR EACH ROW
EXECUTE FUNCTION mark_overdue_invoices();


----------------------------------------------------------------------------------------------------------------------
--> TABLE: ATTENDANCE
-- 1. Automatically calculate hours_worked based on check_in and check_out
CREATE OR REPLACE FUNCTION calculate_hours_worked()
RETURNS TRIGGER AS $$
BEGIN
    -- Only calculate if both check_in and check_out are provided
    IF NEW.check_in IS NOT NULL AND NEW.check_out IS NOT NULL THEN
        NEW.hours_worked := ROUND(EXTRACT(EPOCH FROM (NEW.check_out - NEW.check_in)) / 3600, 2);
    ELSE
        NEW.hours_worked := NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop TRIGGER IF EXISTS trg_calculate_hours ON attendance;

CREATE TRIGGER trg_calculate_hours
BEFORE INSERT OR UPDATE ON attendance
FOR EACH ROW
EXECUTE FUNCTION calculate_hours_worked();

----------------------------------------------------------------------------------------------------------------------
--> TABLE: PAYROLL
-- 1. Automatically calculate net_salary based on gross_salary and deductions
-- 2. Prohibit inserting payroll records for the same employee and month_year combination
-- 3. Prohibit manual update and insert on net_salary column, it should only be calculated based on gross_salary and deductions
CREATE OR REPLACE FUNCTION compute_net_salary()
RETURNS TRIGGER AS $$
BEGIN
    -- Prevent manual insertion of net_salary
    IF TG_OP = 'INSERT' AND NEW.net_salary IS NOT NULL THEN
        RAISE EXCEPTION 'Do not manually insert net_salary. It is computed automatically.';
    END IF;

    -- Prevent manual update of net_salary
    IF TG_OP = 'UPDATE' AND NEW.net_salary IS DISTINCT FROM OLD.net_salary THEN
        RAISE EXCEPTION 'Do not manually update net_salary. Update gross_salary or deductions instead.';
    END IF;

    -- Prevent duplicate payroll for same employee and month
    IF TG_OP = 'INSERT' THEN
        IF EXISTS (
            SELECT 1
            FROM payroll
            WHERE employee_id = NEW.employee_id
              AND month_year = NEW.month_year
        ) THEN
            RAISE EXCEPTION 'Payroll already exists for employee_id % in month %',
                NEW.employee_id, NEW.month_year;
        END IF;
    END IF;

    -- Compute net salary
    NEW.net_salary := NEW.gross_salary - COALESCE(NEW.deductions, 0);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: fires before insert or update
DROP TRIGGER IF EXISTS trg_compute_net_salary ON payroll;

CREATE TRIGGER trg_compute_net_salary
BEFORE INSERT OR UPDATE ON payroll
FOR EACH ROW
EXECUTE FUNCTION compute_net_salary();

----------------------------------------------------------------------------------------------------------------------
--> TABLE: INVENTORY
    --TO PREVENT DUPLICATES
ALTER TABLE inventory
ADD CONSTRAINT unique_product_store UNIQUE (product_id, store_id);
