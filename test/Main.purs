module Test.Main where

import Prelude

import Control.Monad.Eff.Class (liftEff)
import Data.Function.Uncurried as FU
import FFIProps as FP
import Test.Unit as TU
import Test.Unit.Assert as Assert
import Test.Unit.Main as TUM
import Type.Prelude (SProxy(..))

foreign import data MyObject :: Type
foreign import myObject
  :: FP.Object
       MyObject
       ( method :: FU.Fn2 Int Int Int
       , thing1 :: Int
       , thing2 :: Int
       )

main :: _
main = TUM.runTest do
  TU.suite "FFIProps" do
    TU.test "get works" do
      method <- liftEff $ FP.unsafeGetProp
        (SProxy :: SProxy "method")
        myObject
      Assert.assert "test method" $ (FU.runFn2 method 1 2) == 3
    TU.test "set works" do
      liftEff $ FP.unsafeSetProp
        (SProxy :: SProxy "thing1")
        3
        myObject
      thing1 <- liftEff $ FP.unsafeGetProp
        (SProxy :: SProxy "thing1")
        myObject
      Assert.assert "test thing1" $ thing1 == 3
    TU.test "modify works" do
      liftEff $ FP.unsafeModifyProp
        (SProxy :: SProxy "thing2")
        ((+) 1)
        myObject
      thing2 <- liftEff $ FP.unsafeGetProp
        (SProxy :: SProxy "thing2")
        myObject
      Assert.assert "test thing2" $ thing2 == 3

