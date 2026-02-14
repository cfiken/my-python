"""Tests for config module."""

from myapp.utils.config import Settings, get_settings


class TestSettings:
    def test_default_values(self) -> None:
        settings = Settings(app_env="test")
        assert settings.app_env == "test"
        assert settings.log_level == "INFO"

    def test_get_settings_returns_instance(self) -> None:
        get_settings.cache_clear()
        settings = get_settings()
        assert isinstance(settings, Settings)
