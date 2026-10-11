local awful = require("awful")

-- Local references to Lua standard libraries/functions.
-- Some are unused in this file; they could be removed.
local tostring = tostring
local string = string
local ipairs = ipairs
local math = math
local os = os

-- Table containing the functions exported by this module.
local _run = {}

-- Launch CMD only if no process with its executable name exists
-- for the current user. Extracts the first word of CMD as the
-- process name to search for.
function _run.run_once_pgrep(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")

    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end

    -- pgrep -x matches the exact process name.
    -- || executes CMD only if pgrep finds no matching process.
    awful.spawn.easy_async_with_shell(
        string.format(
            "pgrep -u $USER -x %s > /dev/null || (%s)",
            findme, cmd
        )
    )
end

-- Alternative run-once implementation using ps.
-- FINDME is the process name; CMD is what gets launched.
function _run.run_once_ps(findme, cmd)
    -- ps -C lists processes by name; wc -l counts its output.
    -- The header means a count of 1 indicates no matching process.
    awful.spawn.easy_async_with_shell(
        string.format("ps -C %s|wc -l", findme),
        function(stdout)
            if tonumber(stdout) == 1 then
                awful.spawn(cmd, false)
            end
        end
    )
end

-- Search the entire process listing for CMD as text.
-- Launch CMD if no matching line is found.
-- Less precise than pgrep; can produce false matches.
function _run.run_once_grep(command)
    awful.spawn.easy_async_with_shell(
        string.format(
            "ps aux | grep '%s' | grep -v 'grep'",
            command
        ),
        function(stdout)
            if stdout == "" or stdout == nil then
                awful.spawn(command, false)
            end
        end
    )
end

-- Check whether COMMAND appears in the process listing.
-- Call running_callback if found, otherwise call
-- not_running_callback. Neither callback is mandatory.
-- This function checks status; it does not launch the program.
function _run.check_if_running(
    command,
    running_callback,
    not_running_callback
)
    awful.spawn.easy_async_with_shell(
        string.format(
            "ps aux | grep '%s' | grep -v 'grep'",
            command
        ),
        function(stdout)
            if stdout == "" or stdout == nil then
                if not_running_callback ~= nil then
                    not_running_callback()
                end
            else
                if running_callback ~= nil then
                    running_callback()
                end
            end
        end
    )
end

-- Return the table so other files can use these functions.
return _run
