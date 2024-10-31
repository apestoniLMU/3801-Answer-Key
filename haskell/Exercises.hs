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

{- | Returns the result of a given function applied to the first item in the given array that satisfies the given
 predicate.
-}
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs predicate func = func <$> find predicate xs

-- Generates an infinite sequence of powers of a given base.
powers :: Integral x => x -> [x]
powers base = map (base^) [0..]

{- Returns the number of lines in the given file that are (1) not empty, (2) not all whitespace, and (3) whose first
 character is not '#'.
-}
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do
    document <- readFile filePath
    let allWhiteSpace = all isSpace
        trimStart = dropWhile isSpace
        isMeaningful line =
            not (allWhiteSpace line) &&
            not ("#" `isPrefixOf` (trimStart line))
    return $ length $ filter isMeaningful $ lines document

-- A type that supports calculations for its volume and surface area.
data Shape
    = Box  Double Double Double
    | Sphere Double
    deriving (Eq, Show)

-- Returns the volume of the given shape.
volume :: Shape -> Double
volume (Box w l d) = w * l * d
volume (Sphere radius) = (4 / 3) * pi * (radius ^ 3)

-- Returns the surface area of the given shape.
surfaceArea :: Shape -> Double
surfaceArea (Box w l d) = 2 * ((w * l) + (w * d) + (l * d))
surfaceArea (Sphere radius) = 4 * pi * (radius ^ 2)

-- A data type that represents an empty or non-empty node in a generic binary search tree.
data BST a = Empty | Node a (BST a) (BST a)
    deriving (Eq)

-- Inserts a new value into a BST.
insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
    | x < y     = Node y (insert x left) right
    | x > y     = Node y left (insert x right)
    | otherwise = Node y left right

-- Containment check for a BST.
contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x < y     = contains x left
    | x > y     = contains x right
    | otherwise = True

-- Returns the size of a BST.
size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

-- Returns a list of the elements in a BST in order.
inorder :: BST a -> [a]
inorder Empty = []
inorder (Node x left right) = inorder left ++ [x] ++ inorder right

-- Returns a string representation of a BST.
instance (Show a) => Show (BST a) where
    show :: Show a => BST a -> String
    show Empty = "()"
    show (Node x left right) =
        let full = "(" ++ show left ++ show x ++ show right ++ ")" in
        unpack $ replace (pack "()") (pack "") (pack full)