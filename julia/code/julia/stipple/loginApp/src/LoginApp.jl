module LoginApp

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = LoginApp))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = LoginApp.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
