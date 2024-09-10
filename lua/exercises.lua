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
Quaternion = {}
Quaternion.mt = {}

-- Constructor.
function Quaternion.new(x, y, z, w)
  local quaternion = {}
  setmetatable(quaternion, Quaternion.mt)

  quaternion.a = x
  quaternion.b = y
  quaternion.c = z
  quaternion.d = w

  return quaternion
end

-- Add.
function Quaternion.addQuat(q1, q2)
  local q = Quaternion.new
  (
  q1.a + q2.a,
  q1.b + q2.b,
  q1.c + q2.c,
  q1.d + q2.d
  )
  return q
end

Quaternion.mt.__add = Quaternion.addQuat

-- Multiply.
function Quaternion.multQuat(q1, q2)
  return Quaternion.new
  (
  q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,      -- 1
  q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,      -- i
  q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,      -- j
  q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a       -- k
  )
end

Quaternion.mt.__mul = Quaternion.multQuat

-- String.
function Quaternion.tostring(quaternion)
  local str = {}
  local ret = ""

  -- Special formatting for the first coefficient.
  if quaternion.a ~= 0 then
    table.insert(str, quaternion.a)
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
  format_coefficient(quaternion.b, "i")
  format_coefficient(quaternion.c, "j")
  format_coefficient(quaternion.d, "k")

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

Quaternion.mt.__tostring = Quaternion.tostring

-- Returns the coefficients.
function Quaternion:coefficients()
  return { self.a, self.b, self.c, self.d }
end

-- Returns the conjugate.
function Quaternion:conjugate()
  return Quaternion.new
  (
    self.a,
    -self.b,
    -self.c,
    -self.d
  )
end

-- Equality.
function Quaternion.equalQual(q1, q2)
  return (
    q1.a == q2.a and
    q1.b == q2.b and
    q1.c == q2.c and
    q1.d == q2.d
  )
end

Quaternion.mt.__eq = Quaternion.equalQual