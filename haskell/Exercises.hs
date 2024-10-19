module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

-- Write your first then apply function here
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs predicate func = fmap func (find predicate xs)

-- Write your infinite powers generator here
powers :: Integral x => x -> [x]
powers base = map (base^) [0..]

-- Helper function for line filtering readability
isValidLine :: String -> Bool
isValidLine line = not (null stripped) && head stripped /= '#'
  where stripped = dropWhile isSpace line

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do
  text <- readFile filePath
  let linesOfText = lines text
  let validLines = filter isValidLine linesOfText
  return (length validLines)

-- Write your shape data type here

-- Write your binary search tree algebraic type here
