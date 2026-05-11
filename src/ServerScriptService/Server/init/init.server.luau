--!strict
local Object = require(game.ReplicatedStorage.Shared.Classes.Object)
local Server = require(script.server)
Server:run()

print("waiting for server...")
task.wait(15)
print("\nObject after GC:")
print(Object)
