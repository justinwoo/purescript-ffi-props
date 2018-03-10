module FFIProps where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried as EU
import Type.Prelude (class IsSymbol, SProxy(..), reflectSymbol)

-- | a newtype for an object that you define
newtype Object object (properties :: # Type) = Object object

unsafeGetProp
  :: forall o p p' name ty e
   . IsSymbol name
  => RowCons name ty p' p
  => SProxy name
  -> Object o p
  -> Eff e ty
unsafeGetProp _ = EU.runEffFn2 _unsafeGetProp name
  where
    name = reflectSymbol (SProxy :: SProxy name)

unsafeSetProp
  :: forall o p p' name ty e
   . IsSymbol name
  => RowCons name ty p' p
  => SProxy name
  -> ty
  -> Object o p
  -> Eff e Unit
unsafeSetProp _ = EU.runEffFn3 _unsafeSetProp name
  where
    name = reflectSymbol (SProxy :: SProxy name)

unsafeModifyProp
  :: forall o p p' name ty e
   . IsSymbol name
  => RowCons name ty p' p
  => SProxy name
  -> (ty -> ty)
  -> Object o p
  -> Eff e Unit
unsafeModifyProp _ = EU.runEffFn3 _unsafeModifyProp name
  where
    name = reflectSymbol (SProxy :: SProxy name)

foreign import _unsafeGetProp :: forall o ty e. EU.EffFn2 e String o ty
foreign import _unsafeSetProp :: forall o ty e. EU.EffFn3 e String ty o Unit
foreign import _unsafeModifyProp :: forall o ty e. EU.EffFn3 e String (ty -> ty) o Unit
