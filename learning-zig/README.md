# ZIG is a super cool language and here I am learning it.

## https://ziglearn.org/

This commit is going to be pushed when I am midway through chapter 1,  I just got to "optionals". I streamed myself looking at the learning docs.


### random usefulness
I used https://github.com/marler8997/zigup to manage my zig version. 



### notes on memory allocation(see memory-allocation-tests.zig):
* std.heap.page_allocator is the most basic allocater -- it will claim an entire page of memory from your OS when you call it.
* std.heap.FixedBufferAllocator - allocates into a fixed buffer does not make any heap allocations.
* std.heap.ArenaAllocator - TAkes in child allocator, allows to allocate many times with only 1 free.
* alloc and free are used for slices. Single items can be better to use create and destroy.
* general purpose allocator -- always designed for safety over performance, but may still be many times faster than page_allocator.


### Doc generation
* I don't remember how I generated docs automatically or if they are supposed to be pushed into git.
* I'm pushing them because I think it's a cool zig feature and I'm cleaning up this repository and my pc in general.
* Pretty sure Loris Cro(kristoff) is the one who built this feature but I'm not going to research it currently.
* I removed the docs from git. Maybe the intention is to publish during CI and not commit anything to git. That makes more sense anyway.


