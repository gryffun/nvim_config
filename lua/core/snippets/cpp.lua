local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    -- SDL main callback define
    s({
        trig = "#define SDL_MAIN_USE_CALLBACKS",
        desc = "Header section for SDL3 main file",
        wordTrig = true,
    }, {
        t({
            "#define SDL_MAIN_USE_CALLBACKS 1 /* use the callbacks instead of main() */",
            "#include <SDL3/SDL.h>",
            "#include <SDL3/SDL_main.h>",
        })
    }),

    -- Window dimensions
    s({
        trig = "window_dimensions",
        desc = "Set up constants for window dimensions",
    }, fmta([[
        #define WINDOW_WIDTH  <>
        #define WINDOW_HEIGHT <>
    ]], {
        i(1, "width"), i(2, "height")
    })),

    -- Global variables for OpenGL
    s({
        trig = "sdl_globals_gl",
        desc = "Add SDL3 globals for OpenGL",
    }, t({
        "static SDL_Window *window = NULL;",
        "static SDL_GLContext gl_context = NULL;",
    })),

    -- SDL_AppInit (Basic)
    s({
        trig = "SDL_AppInit",
        desc = "Basic SDL3 app init callback",
    }, fmta([[
        SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[])
        {
            SDL_SetAppMetadata("<>", "<>", "<>");

            // Check SDL can initialize
            if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) != 0) {
                SDL_Log("Couldn't init SDL: %s", SDL_GetError());
                return SDL_APP_FAILURE;
            }

            // Create window and renderer
            if (!SDL_CreateWindowAndRenderer("<>", 640, 480, 0, &window, &renderer)) {
                SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
                return SDL_APP_FAILURE;
            }

            return SDL_APP_CONTINUE;
        }
    ]], {
        i(1, "AppName"),
        i(2, "1.0"),
        i(3, "com.example.app"),
        i(4, "Window Title")
    })),

    -- SDL_AppInit (OpenGL version)
    s({
        trig = "sdl_app_init_gl",
        desc = "AppInit for OpenGL with GLAD",
    }, fmta([[
        SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[])
        {
            SDL_SetAppMetadata("<>", "<>", "<>");

            if (SDL_Init(SDL_INIT_VIDEO) != 0) {
                SDL_Log("Couldn't initialize SDL: %s", SDL_GetError());
                return SDL_APP_FAILURE;
            }

            // Set OpenGL attributes
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
            SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
            SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
            SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);

            // Create window
            window = SDL_CreateWindow("<>", WINDOW_WIDTH, WINDOW_HEIGHT,
                                     SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);
            if (!window) {
                SDL_Log("Couldn't create window: %s", SDL_GetError());
                return SDL_APP_FAILURE;
            }

            // Create GL context
            gl_context = SDL_GL_CreateContext(window);
            if (!gl_context) {
                SDL_Log("Couldn't create GL context: %s", SDL_GetError());
                return SDL_APP_FAILURE;
            }

            // Load OpenGL functions
            if (!gladLoadGLLoader((GLADloadproc)SDL_GL_GetProcAddress)) {
                SDL_Log("Failed to load GL functions");
                return SDL_APP_FAILURE;
            }

            // Set initial viewport
            glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);

            return SDL_APP_CONTINUE;
        }
    ]], {
        i(1, "AppName"),
        i(2, "1.0"),
        i(3, "com.example.app"),
        i(4, "OpenGL Window")
    })),

    -- SDL_AppEvent
    s({
        trig = "SDL_AppEvent",
        desc = "Basic event handling template",
    }, {
        t({
            "SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event)",
            "{",
            "    if (event->type == SDL_EVENT_QUIT) {",
            "        return SDL_APP_SUCCESS;",
            "    }",
            "    return SDL_APP_CONTINUE;",
            "}"
        })
    }),

    -- SDL_AppIterate (Basic)
    s({
        trig = "SDL_AppIterate",
        desc = "Basic frame iteration template",
    }, fmta([[
        SDL_AppResult SDL_AppIterate(void *appstate)
        {
            <>
            SDL_RenderPresent(renderer);
            return SDL_APP_CONTINUE;
        }
    ]], {
        i(1, "// Add frame logic here")
    })),

    -- SDL_AppIterate (OpenGL version)
    s({
        trig = "sdl_app_iter_gl",
        desc = "OpenGL frame iteration template",
    }, fmta([[
        SDL_AppResult SDL_AppIterate(void *appstate)
        {
            // Clear screen
            glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);

            <>

            // Swap buffers
            SDL_GL_SwapWindow(window);
            return SDL_APP_CONTINUE;
        }
    ]], {
        i(1, "// Add OpenGL drawing here")
    })),

    -- SDL_AppQuit (Basic)
    s({
        trig = "SDL_AppQuit",
        desc = "Basic app cleanup template",
    }, t({
        "void SDL_AppQuit(void *appstate, SDL_AppResult result)",
        "{",
        "    // SDL cleans up automatically",
        "}"
    })),

    -- SDL_AppQuit (OpenGL version)
    s({
        trig = "sdl_app_quit_gl",
        desc = "OpenGL app cleanup template",
    }, fmta([[
        void SDL_AppQuit(void *appstate, SDL_AppResult result)
        {
            // Clean up OpenGL resources
            <>

            // Delete context and window
            SDL_GL_DeleteContext(gl_context);
            SDL_DestroyWindow(window);
        }
    ]], {
        i(1, "// Add OpenGL cleanup code")
    }))

    -- Divider that I like using
    s("/*-------*/", {
        t("/*----------------------------------------------------------------------------*/"),
    }),
}
