function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Returns a lowercased version of the first string in the given list that satisfies the given predicate.
function first_then_lower_case(strings, predicate)
  for _, str in ipairs(strings) do
    if predicate(str) then
      return string.lower(str)
    end
  end

  return nil
end

-- Returns a generator that returns the successive powers of the given base, up to but not exceeding the given limit.
function powers_generator(base, limit)
  local power = 1
  return coroutine.create(function()
    -- Yield and raise the power until the limit is reached.
    while power <= limit do
      coroutine.yield(power)
      power = power * base
    end
  end)
end

-- Chainable function that concatenates the strings given in sequential calls, until no string is passed.
function say(word)
  -- If no word is given, return an empty string.
  if word == nil then
    return ""
  end

  -- Recursive function: when given nothing, returns the words passed to the say function chain. Otherwise, makes a
  -- recursive call concatenating the given string.
  return function(next)
    if next == nil then
      return word
    else
      return say(word .. " " .. next)
    end
  end
end

-- Returns the number of lines in the given file that are NOT (1) empty, (2) entirely whitespace, or (3) whose first
-- character is '#'.
function meaningful_line_count(file_path)
  -- Open the file; throw an error if it can't be found.
  file = io.open(file_path, "r")
  if file == nil then
    error("No such file")
  end

  count = 0
  for line in file:lines() do
    -- Trim whitespace
    line = string.gsub(line, "%s", "")

    -- Count line if it's NOT (1) whitespace or (2) its first (trimmed) character is '#'.
    if (line ~= "") and (string.sub(line, 1, 1) ~= '#') then
      count = count + 1
    end
  end

  file:close()

  return count
end

-- Metatable for quaternions.
Quaternion = {} -- Forward declaration needed for metatable.
quaternion_mt = {
  __index = {

    -- Returns this quaternion's coefficients in a table.
    coefficients = function(self)
      return { self.a, self.b, self.c, self.d }
    end,

    -- Returns this quaternion's conjugate.
    conjugate = function(self)
      return Quaternion.new
      (
        self.a,
        -self.b,
        -self.c,
        -self.d
      )
    end
  },

  -- Add.
  __add = function(self, other)
    return Quaternion.new
    (
      self.a + other.a,
      self.b + other.b,
      self.c + other.c,
      self.d + other.d
    )
  end,

  -- Multiply.
  __mul = function(self, other)
    return Quaternion.new
    (
      self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,      -- 1
      self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,      -- i
      self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,      -- j
      self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a       -- k
    )
  end,

  -- Equality.
  __eq = function(self, other)
    return
    (
      self.a == other.a and
      self.b == other.b and
      self.c == other.c and
      self.d == other.d
    )
  end,

  -- To-string.
  __tostring = function(self)
    local str = {}
    local ret = ""

    -- Special formatting for the first coefficient.
    if self.a ~= 0 then
      table.insert(str, self.a)
    end

    -- Helper for formatting a single coefficient.
    function format_coefficient(value, symbol)
      if value == 0 then
        return
      end

      if value > 0 then
        if #str > 0 then
          table.insert(str, "+")
        end

        if value == 1 then
          table.insert(str, symbol)
        else
          table.insert(str, value .. symbol)
        end
      else
        if value == -1 then
          table.insert(str, "-" .. symbol)
        else
          table.insert(str, value .. symbol)
        end
      end
    end

    -- Format 2nd, 3rd, and 4th coefficients.
    format_coefficient(self.b, "i")
    format_coefficient(self.c, "j")
    format_coefficient(self.d, "k")

    -- Special case for all zeroes.
    if #str == 0 then
      return "0"
    end

    -- Build and return final string.
    for _, word in ipairs(str) do
      ret = ret .. word
    end

    return ret
  end
}

-- Quaternion constructor. Links the instance to the metatable.
Quaternion.new = function (x, y, z, w)
    return setmetatable({a = x, b = y, c = z, d = w}, quaternion_mt)
end