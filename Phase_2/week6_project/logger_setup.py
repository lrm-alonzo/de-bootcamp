# logger_setup.py
import logging
from logging.handlers import RotatingFileHandler

def get_logger(
    name: str,
    log_file: str = "etl_pipeline.log",
    level: int = logging.INFO,
    mode: str = "append",   # options: "append", "overwrite", "rotate"
    max_bytes: int = 5*1024*1024,
    backup_count: int = 3
) -> logging.Logger:
    """
    Returns a configured logger that can be reused across scripts.

    Args:
        name (str): Name of the logger (usually __name__ of the calling module).
        log_file (str): Path to the log file.
        level (int): Logging level (default INFO).
        mode (str): Logging mode:
            - "append": keep adding to the same file
            - "overwrite": start fresh each run
            - "rotate": rotate files when max_bytes is reached
        max_bytes (int): Max size per log file before rotation (only for "rotate").
        backup_count (int): Number of rotated backups to keep (only for "rotate").
    """
    logger = logging.getLogger(name)
    logger.setLevel(level)

    # Prevent duplicate handlers if logger is reused
    if not logger.handlers:
        # Console handler
        console_handler = logging.StreamHandler()
        console_handler.setLevel(level)

        # File handler depending on mode
        if mode == "append":
            file_handler = logging.FileHandler(log_file, mode="a")
        elif mode == "overwrite":
            file_handler = logging.FileHandler(log_file, mode="w")
        elif mode == "rotate":
            file_handler = RotatingFileHandler(
                log_file, maxBytes=max_bytes, backupCount=backup_count
            )
        else:
            raise ValueError("Invalid mode. Use 'append', 'overwrite', or 'rotate'.")

        file_handler.setLevel(level)

        # Formatter
        formatter = logging.Formatter(
            "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
        )
        console_handler.setFormatter(formatter)
        file_handler.setFormatter(formatter)

        # Add handlers
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)

    return logger
