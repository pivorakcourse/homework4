class String
  # Returns the string, first removing all whitespace on both ends of
  # the string, and then changing remaining consecutive whitespace
  # groups into one space each.
  def squish
    dup.squish!
  end

  # Performs a destructive squish. See String#squish.
  def squish!
    gsub!(/[[:space:]]+/, " ")
    strip!
    self
  end

  # Returns a new string with all occurrences of the patterns removed.
  # => "foo bar test"
  def remove(*patterns)
    dup.remove!(*patterns)
  end

  # Alters the string by removing all occurrences of the patterns.
  def remove!(*patterns)
    patterns.each do |pattern|
      gsub! pattern, ""
    end

    self
  end

  # Truncates a given +text+ after a given <tt>length</tt> if +text+ is longer than <tt>length</tt>:
  #
  def truncate(truncate_at, options = {})
    return dup unless length > truncate_at

    omission = options[:omission] || "..."
    length_with_room_for_omission = truncate_at - omission.length
    stop = \
    if options[:separator]
      rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
    else
      length_with_room_for_omission
    end

    "#{self[0, stop]}#{omission}"
  end

  # Truncates a given +text+ after a given number of words (<tt>words_count</tt>):
  #
  def truncate_words(words_count, options = {})
    sep = options[:separator] || /\s+/
    sep = Regexp.escape(sep.to_s) unless Regexp === sep
    if self =~ /\A((?>.+?#{sep}){#{words_count - 1}}.+?)#{sep}.*/m
      $1 + (options[:omission] || "...")
    else
      dup
    end
  end

  def at(position)
    self[position]
  end

  # Returns a substring from the given position to the end of the string.
  # If the position is negative, it is counted from the end of the string.
  def from(position)
    self[position..-1]
  end

  # Returns a substring from the beginning of the string to the given position.
  # If the position is negative, it is counted from the end of the string.
  def to(position)
    self[0..position]
  end

  # Returns the first character. If a limit is supplied, returns a substring
  # from the beginning of the string until it reaches the limit value. If the
  # given limit is greater than or equal to the string length, returns a copy of self.
  def first(limit = 1)
    if limit == 0
      ""
    elsif limit >= size
      dup
    else
      to(limit - 1)
    end
  end

  # Returns the last character of the string. If a limit is supplied, returns a substring
  # from the end of the string until it reaches the limit value (counting backwards). If
  # the given limit is greater than or equal to the string length, returns a copy of self.

  def last(limit = 1)
    if limit == 0
      ""
    elsif limit >= size
      dup
    else
      from(-limit)
    end
  end
end
