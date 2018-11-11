module Unison.Codebase.TermEdit where

import Unison.Hashable (Hashable)
import qualified Unison.Hashable as H
import Unison.Names (Referent)

data TermEdit = Replace Referent Typing | Deprecate
  deriving (Eq, Ord, Show)

referents :: TermEdit -> [Referent]
referents (Replace r _) = [r]
referents Deprecate = []

-- Replacements with the Same type can be automatically propagated.
-- Replacements with a Subtype can be automatically propagated but may result in dependents getting more general types, so requires re-inference.
-- Replacements of a Different type need to be manually propagated by the programmer.
data Typing = Same | Subtype | Different
  deriving (Eq, Ord, Show)

instance Hashable Typing where
  tokens Same = [H.Tag 0]
  tokens Subtype = [H.Tag 1]
  tokens Different = [H.Tag 2]

instance Hashable TermEdit where
  tokens (Replace r t) = [H.Tag 0] ++ H.tokens r ++ H.tokens t
  tokens Deprecate = [H.Tag 1]

toReference :: TermEdit -> Maybe Referent
toReference (Replace r _) = Just r
toReference Deprecate     = Nothing
