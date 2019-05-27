#  An Army Of Ones

## Instructions to Start
1. Clone repository: `git clone https://github.com/zheref/CurrencyConverter.git`.
2. Open `CurrencyConverter.xcworkspace` by double-clicking it.
3. Click _Run_ to start simulator.
4. Once the app starts make sure to have **Software Keyboard** enabled by going to Hardware -> Keyboard -> Toggle Software Keyboard.

## Considerations
1. I didn't have the chance to start this test right on Friday when I received it since I didn't have the chance to confirm Alejandra when I would have time to start it. So I started it first spare time I had yesterday in the middle of the afternoon. _Just to consider_ in case you see something I might have done in a rush.
2. If you're running on the Simulator instead of an actual device, I would strongly suggest to used the Software Keyboard since it will stop you from entering non-numeric characters on the _Amount of Dollars_ text field.

## Technical Details
**Source code language:** Swift 5.0  
**Patterns used:** MVP, Singleton, Delegation, Decorator  
**Good practices followed:**  Dependency Injection, Localized Strings, Avoiding Literals, AutoLayout, S.O.L.I.D.

### Target
The app was set to target iOS only and it was made Universal by also taking advantage of Autolayout in order to support multiple screen sizes by using only one storyboard and libraries Autolayout ready capable to resize and reaccomodate accordingly.

### Practices
Accurate names for classes and other symbols were introduced, matching the needs of the chosen architectural pattern as well as methods names for comforming as accurately as possible to the Swift Design Guidelines.

The code was properly separated into corresponding classes with different responsibilities as well as the instructions correctly distributed to avoid methods that are too long and too complex to read as well as being able to reuse them as calls or closures for multiple purposes.

Constant nested types structs were created in order to avoid the use of literals and promote the reuse of multiple literals that are used all over the code repeateadly. In some cases like in `Currency` this one became an enum to emphasize the set of constants as an unique concept.

Singletons and lazy initialization were used when needed. Copies are in the Localized Strings file in order for the app to be Localization ready (for multiple languages). Dependency Injection was also used to make UI Testing easier and follow the Dependency Inversion Principle of S.O.L.I.D.

Also the UI and UX practices follow the concepts of Human Interface Guidelines proposed and promoted by Apple itself for applications to be easier and more natural to use, specially for already existing iOS consumers.

## FAQ
To the reviewer of this document and test, some points to consider:

1. I literally started just yesterday in the middle of the afternoon which you can confirm by checking at the timestamp of the first revision (commit).
2. I just gave a brief explanation of this resolution's approach: However if further information about a topic is required, I will be pleased to provide an extended explanation.
3. It's important to clarify that some practices were implemented solely in a specific point in order to show my expertise on that.

I hope you like it and feel free to reach out to me for whatever you need.

Peace!
