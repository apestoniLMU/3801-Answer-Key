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

-- Returns a generator that returns the successive powers of the given base, up to but not including the given limit.
function powers_generator(base, limit)
  local power = 1
  -- Create the generator.
  return coroutine.create(function()
    -- Yield and raise the power until reaching the limit.
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

-- Write your line count function here
function meaningful_line_count(file_path)
  -- Open the file.
  file = io.open(file_path, "r")

  -- Ensure the file exists.
  if file == nil then
    error("No such file")
  end

  count = 0
  for line in file:lines() do
    -- Trim whitespace
    line = string.gsub(line, "%s", "")

    -- Count line if it's NOT (1) whitespace or (2) first char is '#'.
    if (line ~= "") and (string.sub(line, 1, 1) ~= '#') then
      count = count + 1
    end
  end

  file:close()

  return count
end

-- Table declaration.
Quaternion = (function (class)
  class.new = function (x, y, z, w)
    return setmetatable({a = x, b = y, c = z, d = w}, {
      __index = {
        coefficients = function(self)
          return { self.a, self.b, self.c, self.d }
        end,

        conjugate = function(self)
          return class.new
          (
            self.a,
            -self.b,
            -self.c,
            -self.d
          )
        end
      },

      __add = function(self, other)
        return class.new
        (
          self.a + other.a,
          self.b + other.b,
          self.c + other.c,
          self.d + other.d
        )
      end,

      __mul = function(self, other)
        return class.new
        (
        self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,      -- 1
        self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,      -- i
        self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,      -- j
        self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a       -- k
        )
      end,

      __eq = function(self, other)
        return
        (
          self.a == other.a and
          self.b == other.b and
          self.c == other.c and
          self.d == other.d
        )
      end,

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

        -- Build final string.
        for _, word in ipairs(str) do
          ret = ret .. word
        end

        return ret
      end
    })
  end
  return class
end)({})