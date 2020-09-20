abstract type LinkedList{T} end

Base.eltype(::Type{<:LinkedList{T}}) where T = T

mutable struct Cons{T} <: LinkedList{T}
    head::T
    tail::Cons{T}
    Cons{T}(h, t) where T = new{T}(h, t)
    Cons{T}() where T = new{T}()
end

cons(h, t::LinkedList{T}) where {T} = Cons{T}(h, t)

nil(T) = Cons{T}()
nil() = nil(Any)
isnil(x::Cons) = !isdefined(x, :tail)

head(x::Cons) = x.head
tail(x::Cons) = x.tail

Base.:(==)(x::Cons, y::Cons) = begin
    isnil(x) && isnil(y) && return true
    return !isnil(x) && !isnil(y) && (x.head == y.head) && (x.tail == y.tail)
end

function Base.show(io::IO, l::LinkedList{T}) where T
    if isnil(l)
        if T === Any
            print(io, "nil()")
        else
            print(io, "nil(", T, ")")
        end
    else
        print(io, "list(")
        show(io, head(l))
        for t in tail(l)
            print(io, ", ")
            show(io, t)
        end
        print(io, ")")
    end
end

list() = nil()

function list(elts...)
    l = nil()
    for i=length(elts):-1:1
        l = cons(elts[i],l)
    end
    return l
end

function list(elts::T...) where T
    l = nil(T)
    for i=length(elts):-1:1
        l = cons(elts[i],l)
    end
    return l
end

function Base.length(l::Cons)
    n = 0
    for i in l
        n += 1
    end
    return n
end

function Base.map(f::Base.Callable, l::Cons{T}) where T
    isnil(l) && return l
    first = f(l.head)
    l2 = cons(first, nil(typeof(first) <: T ? T : typeof(first)))
    for h in l.tail
        l2 = cons(f(h), l2)
    end
    reverse(l2)
end

function Base.filter(f::Function, l::LinkedList{T}) where T
    l2 = nil(T)
    for h in l
        if f(h)
            l2 = cons(h, l2)
        end
    end
    reverse(l2)
end

function Base.reverse(l::LinkedList{T}) where T
    l2 = nil(T)
    for h in l
        l2 = cons(h, l2)
    end
    return l2
end

function Base.copy(l::Cons)
    isnil(l) && return l
    l2 = reverse(reverse(l))
end

Base.cat(lst::LinkedList) = lst

function Base.cat(lst::LinkedList, lsts::LinkedList...)
    T = typeof(lst).parameters[1]
    n = length(lsts)
    for i = 1:n
        T2 = typeof(lsts[i]).parameters[1]
        T = typejoin(T, T2)
    end

    l2 = nil(T)
    for h in lst
        l2 = cons(h, l2)
    end

    for i = 1:n
        for h in lsts[i]
            l2 = cons(h, l2)
        end
    end

    reverse(l2)
end

function Base.iterate(l::LinkedList, state::Cons = l)
    isnil(state) && return nothing
    state.head, state.tail
end
