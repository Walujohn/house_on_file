// Entry point for the build script in your package.json
import "./controllers"
import "@hotwired/turbo-rails"

// The two following lines disable Turbo on the whole application
//import { Turbo } from "@hotwired/turbo-rails"
//Turbo.session.drive = false