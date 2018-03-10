# PureScript FFI Props

Helper to make FFI props access and usage safe-ish and easier.

tl;dr `newtype Object object (properties :: # Type) = Object object`

## Usage

For example, given some JS object like this:

```js
exports.myObject = {
  method: function(a, b) {
    return a + b;
  },
  thing1: 1,
  thing2: 2
};
```

You can define a foreign data type and create a newtype for the Object newtype:

```hs
foreign import data MyObject :: Type
foreign import myObject
  :: FP.Object
       MyObject
       ( method :: FU.Fn2 Int Int Int
       , thing1 :: Int
       , thing2 :: Int
       )
```

Then you can use this library to get/set/modify fields as necessary (ideally providing some bindings).

```hs
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
```
