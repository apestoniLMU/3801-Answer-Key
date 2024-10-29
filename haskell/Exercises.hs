module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount,
      Shape(..),
      BST(Empty),
      volume,
      surfaceArea,
      size,
      contains,
      insert,
      inorder
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
data Shape
  = Box  Double Double Double
  | Sphere Double
  deriving (Eq, Show)

volume :: Shape -> Double
volume (Box width height depth) = width * height * depth
volume (Sphere radius) = (4 / 3) * pi * radius^3

surfaceArea :: Shape -> Double
surfaceArea (Box width height depth) = 2 * (width * height + width * depth + height * depth)
surfaceArea (Sphere radius) = 4 * pi * radius^2

-- Write your binary search tree algebraic type here
data BST a = Empty | Node a (BST a) (BST a)
    deriving (Eq)

insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
    | x < y     = Node y (insert x left) right
    | x > y     = Node y left (insert x right)
    | otherwise = Node y left right

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x < y     = contains x left
    | x > y     = contains x right
    | otherwise = True

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node x left right) = inorder left ++ [x] ++ inorder right

instance (Show a) => Show (BST a) where
  show :: Show a => BST a -> String
  show Empty = "()"
  show (Node x left right) = 
    let full = "(" ++ show left ++ show x ++ show right ++ ")" in
    unpack $ replace (pack "()") (pack "") (pack full)