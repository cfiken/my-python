"""Entry point for myapp."""

import logging

from myapp.utils.config import get_settings
from myapp.utils.logger import setup_logging


def main() -> None:
    setup_logging()
    settings = get_settings()
    logger = logging.getLogger(__name__)
    logger.info("Starting myapp (env=%s)", settings.app_env)


if __name__ == "__main__":
    main()
