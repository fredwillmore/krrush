class Queue
  def initializer(type)
    @type = type
    @buffer = CircularBuffer.new type
  end

  def enqueue(value)

  end

  def dequeue

  end
end

class messageQueue < Queue
  def initializer
    @buffer = CircularBuffer.new Message
  end
end

class sampleQueue < Queue
  def initializer
    @buffer = CircularBuffer.new NArray.sfloat
  end
end
