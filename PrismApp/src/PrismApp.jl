module PrismApp

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = PrismApp))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = PrismApp.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
