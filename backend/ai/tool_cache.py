"""
Simple in-memory cache with TTL for expensive API calls (e.g., Tavily).
"""
import hashlib
import time
from typing import Optional, Any, Dict

# Default TTL: 24 hours (in seconds)
DEFAULT_TTL = 24 * 60 * 60

# In-memory cache storage: {cache_key: (value, expiry_timestamp)}
_cache: Dict[str, tuple[Any, float]] = {}


def _generate_cache_key(prefix: str, **kwargs) -> str:
    """Generate a cache key from prefix and keyword arguments."""
    # Sort kwargs for consistent key generation
    sorted_items = sorted(kwargs.items())
    key_string = f"{prefix}:{sorted_items}"
    return hashlib.md5(key_string.encode()).hexdigest()


def cache_get(key: str) -> Optional[Any]:
    """
    Retrieve a value from cache if it exists and hasn't expired.

    Args:
        key: The cache key

    Returns:
        The cached value, or None if not found/expired
    """
    if key not in _cache:
        return None

    value, expiry = _cache[key]
    if time.time() > expiry:
        # Expired, remove and return None
        del _cache[key]
        return None

    return value


def cache_set(key: str, value: Any, ttl: int = DEFAULT_TTL) -> None:
    """
    Store a value in cache with TTL.

    Args:
        key: The cache key
        value: The value to store
        ttl: Time-to-live in seconds (default: 24 hours)
    """
    expiry = time.time() + ttl
    _cache[key] = (value, expiry)


def cache_clear() -> None:
    """Clear all cached values."""
    global _cache
    _cache = {}


def cached_tavily_search(query: str, search_func, ttl: int = DEFAULT_TTL) -> str:
    """
    Execute a Tavily search with caching.

    Args:
        query: The search query
        search_func: The function to call if cache miss
        ttl: Cache TTL in seconds

    Returns:
        The search results (cached or fresh)
    """
    cache_key = _generate_cache_key("tavily", query=query)

    cached = cache_get(cache_key)
    if cached is not None:
        return cached

    # Execute search
    result = search_func(query)
    cache_set(cache_key, result, ttl)

    return result
