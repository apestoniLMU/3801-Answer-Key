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

-- Write your powers generator here

-- Write your say function here

-- Write your line count function here

-- Write your Quaternion table here
