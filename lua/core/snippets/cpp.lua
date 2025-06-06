local ls   = require("luasnip")
local s    = ls.snippet
local t    = ls.text_node
local i    = ls.insert_node
local c    = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        {
            trig = "#define SDL_MAIN_USE_CALLBACKS",
            snippetType = "snippet",
            desc = "Header section for SDL3 main file",
            wordTrig = true,
        },
        {
            t({
                "#define SDL_MAIN_USE_CALLBACKS 1 /* use the callbacks instead of main() */",
                "#include <SDL3/SDL.h>",
                "#include <SDL3/SDL_main.h>",
            }),
        }
    ),
    s(
        {
            trig = "SDL_AppInit",
            snippetType = "snippet",
            desc = "SDL3 App init callback function template",
        },
        fmta(
            [[
            {
            SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[])
            SDL_SetAppMetadata("<>", "<>", "<>");
            // Check SDL can initialise
            if (!SDL_Init(SDL_INIT_VIDEO))
            {
            // if cant init video, return error
            SDL_Log("Couldnt init SDL: %s", SDL_GetError());
            return SDL_APP_FAILURE;
            }

            // actually init the window and renderer
            if (!SDL_CreateWindowAndRenderer("window", 640, 480, 0, &window, &renderer))
            {
            SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
            return SDL_APP_FAILURE;
            }
            return SDL_APP_CONTINUE;
            }
            ]],
            {
                i(1, "screenTitle"),
                i(2, "versionNumber"),
                i(3, "appIdentifier")
            }
        )
    ),
    s(
        {
            trig = "SDL_AppEvent",
            snippetType = "snippet",
            desc = "Basic template for SDL_AppEvent",
        },
        {
            t({
            "SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event)",
            "{",
            "   if (event->type == SDL_EVENT_QUIT)",
            "   {",
            "       return SDL_APP_SUCCESS; // end the program, reporting success to the OS.",
            "   }",
            "   return SDL_APP_CONTINUE;",
            "}",
            })

        }
    ),

    s(
        {
            trig = "SDL_AppQuit",
            snippetType = "snippet",
            desc = "Basic template for SDL_AppQuit"
        },
        {
            t({"void SDL_AppQuit(void *appstate, SDL_AppResult result) {}"})
        }

    ),

    s(
        {
            trig = "SDL_AppIterate",
            snippetType = "snippet",
            desc = "Empty template for SDL_AppIterate",
        },
        fmta(
            [[
            SDL_AppResult SDL_AppIterate(void *appstate) // frame by frame update
            {
                <>
                // Present the final calculated renderer to the window
                SDL_RenderPresent(renderer);
                return SDL_APP_CONTINUE;
            }
            ]],
            {
            i(1, functionBody)
            }

        )
    ),
}
