# ITunesCatalog

A coding challenge requiring that the data layer to contain an internal API mapping to a JSON object.

The main idea of this architecture was to separate responsibilities into individual units. The single responsilbity pattern helps separate concerns and isolate logic to their respective units. This allows for stronger testing and lower coupling. There is some singleton use present, however the project is designed using protocols to allow for easy mocking/faking data. This, in concert with dependency injection (mostly via initializer or property injection in case of view controllers) will provide for isolation in unit testing. Which would aide in refactors later on.
