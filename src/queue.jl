# FIFO queue

type Queue{T}
    store::Deque{T}
end

"""
    Queue(ty{T}[, blksize::Integer])

This is a constructor to create an object of a `Queue`.The block size `blksize` by default is `1024`.
"""
Queue{T}(ty::Type{T}) = Queue(Deque{T}())
Queue{T}(ty::Type{T}, blksize::Integer) = Queue(Deque{T}(blksize))

isempty(s::Queue) = isempty(s.store)
length(s::Queue) = length(s.store)

front(s::Queue) = front(s.store)
back(s::Queue) = back(s.store)

"""
    enqueue!(s::Queue, x)

Inserts the value `x` to the front of the queue `s`.
"""
function enqueue!(s::Queue, x)
    push!(s.store, x)
    s
end

"""
    dequeue!(s::Queue)

Removes an element from the back of the queue `s`.
"""
dequeue!(s::Queue) = shift!(s.store)

# Iterators

start(q::Queue) = start(q.store)
next(q::Queue, s) = next(q.store, s)
done(q::Queue, s) = done(q.store, s)

reverse_iter(q::Queue) = reverse_iter(q.store)
