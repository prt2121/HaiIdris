-- mod from http://mmhelloworld.github.io/blog/2017/01/06/introducing-idris-on-the-jvm-and-an-idris-android-example/
module Main

import IdrisJvm.IO
import Java.Lang

IdrisActivity : Type
IdrisActivity = JVM_Native $ Class "com/pt2121/haiidris/IdrisActivity"

Bundle : Type
Bundle = JVM_Native $ Class "android/os/Bundle"

Context : Type
Context = JVM_Native $ Class "android/content/Context"

View : Type
View = JVM_Native $ Class "android/view/View"

TextView : Type
TextView = JVM_Native $ Class "android/widget/TextView"

Inherits View TextView where {}

CharSequence : Type
CharSequence = JVM_Native $ Class "java/lang/CharSequence"

Inherits CharSequence String where {}

superOnCreate : IdrisActivity -> Bundle -> JVM_IO ()
superOnCreate = invokeInstance "superOnCreate" (IdrisActivity -> Bundle -> JVM_IO ())

getApplicationContext : IdrisActivity -> JVM_IO Context
getApplicationContext = invokeInstance "getApplicationContext" (IdrisActivity -> JVM_IO Context)

newTextView : Context -> JVM_IO TextView
newTextView = FFI.new (Context -> JVM_IO TextView)

setText : Inherits CharSequence charSequence => TextView -> charSequence -> JVM_IO ()
setText this text = invokeInstance "setText" (TextView -> CharSequence -> JVM_IO ()) this (believe_me text)

setContentView : Inherits View view => IdrisActivity -> view -> JVM_IO ()
setContentView this view = invokeInstance "setContentView" (IdrisActivity -> View -> JVM_IO ()) this (believe_me view)

onCreate : IdrisActivity -> Bundle -> JVM_IO ()
onCreate this bundle = do
  superOnCreate this bundle
  context <- getApplicationContext this
  textView <- newTextView context
  setText textView $ "hello, world!"
  setContentView this textView

main : IO ()
main = pure ()

androidExport: FFI_Export FFI_JVM "com/pt2121/haiidris/IdrisActivity extends android/support/v7/app/AppCompatActivity" []
androidExport =
  Fun superOnCreate (Super "onCreate") $
  Fun onCreate (ExportInstance "onCreate") $
  End
