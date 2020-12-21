using Genie.Router

import PageController

# routes
route("/") do
	PageController.m_layout("landing page")
end

route("/first") do
	PageController.m_layout(PageController.page_1())
end

route("/second") do
	PageController.m_layout(PageController.page_2())
end