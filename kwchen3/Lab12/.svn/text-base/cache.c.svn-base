#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "cache.h"

// take the log base 2 of a number       
int log2(int num)
{
	assert((num & (num - 1)) == 0);   // "num" must be a power of 2 !!
	int ret = 0;

	// count the number of 1s in "<num> - 1"
	for (int shifter = num - 1; shifter > 0; shifter >>= 1)
	{
		ret++;
	}

	return ret;
}

// initialize the cache by allocating space for all of the cache
// blocks and initializing them to be invalid and with 0 last access
// times.
void init_cache(cache_t *cache, unsigned size, unsigned nways, unsigned block_size)
{

	int num_blocks;
	// this call will assert if any of the parameters are not powers of 2

	log2(block_size);

	// copy over parameters cache-size, cache->num_blocks, cache->nways, cache->block_size

	num_blocks = size / block_size;
	cache->num_blocks = num_blocks;

	cache->size = size;
	cache->nways = nways;
	cache->block_size = block_size;

	cache->index_bits = log2(num_blocks / nways);
	cache->boff_bits = log2(block_size);
	cache->tag_bits = 32 - cache->index_bits - cache->boff_bits;

	cache->tag_mask = ((1 << cache->tag_bits) - 1) << (cache->boff_bits + cache->index_bits);
	cache->index_mask = ((1 << cache->index_bits) - 1) << (cache->boff_bits);

	// initialize counters and statistics
	cache->LRU_counter = 1;  // for LRU

	// setup bitmak masks for tag and index 

	// dynamically allocate space for cache blocks (this is C's new)
	cache->blocks = (cache_block_t *) malloc(num_blocks * sizeof(cache_block_t));

	// initialize each cache block to be invalid 
	for (int i = 0; i < num_blocks; ++i)
	{
		cache->blocks[i].valid = false;
		cache->blocks[i].last_access_time = 0;
	}
}

void init_stats(stats_t *stats)
{
	stats->accesses = 0;
	stats->hits = 0;
}

// This function returns the cache block which is the "way"th 
// entry in the "index"th set.
cache_block_t * get_block(cache_t *cache, unsigned index, unsigned way)
{
	assert(way < cache->nways);
	unsigned num_sets = cache->num_blocks / cache->nways;
	assert(index < num_sets);
	unsigned i = (index * cache->nways) + way;
	return &cache->blocks[i];
}

// given an address, extract the tag field for cache "cache"
unsigned extract_tag(cache_t *cache, unsigned address)
{
	return ((address & cache->tag_mask) >> (cache->boff_bits + cache->index_bits));
}

// given an address, extract the index field for cache "cache"
unsigned extract_index(cache_t *cache, unsigned address)
{
	return ((address & cache->index_mask) >> cache->boff_bits);
}

// given an address, look up in cache "cache" to see if that 
// address hits.  If it does update the last access time
bool find_block_and_update_lru(cache_t *cache, unsigned address, stats_t *stats)
{
	unsigned tag = extract_tag(cache, address);
	unsigned index = extract_index(cache, address);
	stats->accesses += 1;
	cache->LRU_counter += 1;

	for (unsigned way = 0; way < cache->nways; ++way)
	{
		cache_block_t *block = get_block(cache, index, way);
		if ((block->tag == tag) && block->valid)
		{
			stats->hits += 1;
			block->last_access_time = cache->LRU_counter;
			return true;
		}
	}

	return false;
}

// This function should find the LRU block and replace it 
// with one that contains "address"
void fill_cache_with_block(cache_t *cache, unsigned address)
{
	unsigned tag = extract_tag(cache, address);
	unsigned index = extract_index(cache, address);
	unsigned LRU_index;
	unsigned LRU_time = 2147483647;

	for (unsigned way = 0; way < cache->nways; way++)
	{
		cache_block_t *block = get_block(cache, index, way);
		if (!block->valid)
		{
			block->tag = tag;
			block->valid = true;
			block->last_access_time = cache->LRU_counter;
			return;
		} else if (LRU_time > block->last_access_time)
		{
			LRU_index = way;
			LRU_time = block->last_access_time;
		}
	}
	cache_block_t *block = get_block(cache, index, LRU_index);
	block->tag = tag;
	block->valid = true;
	block->last_access_time = cache->LRU_counter;

	// We technically don't need to check the validity of the blocks we
	// look at, because all invalid blocks will have a last_access_time
	// of 0, but I've added code to do the check, just for completeness

}
