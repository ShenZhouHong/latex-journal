-- Lua function that includes all journal entries in the entries/ directory.
-- It expects all files to be named in ISO 8601 date format (e.g. YYYY-MM-DD),
-- and with the .tex extension only. Upon discovery, the Lua program
-- automatically generates the appropriate LaTeX datetime2 entries with
-- \DTMsavedate{entry} to generate the chapter short-titles. Furthermore, the
-- program also creates a new /part for each month.
--
-- Sources and References:
-- 1. https://tex.stackexchange.com/a/488674
-- 2. https://tex.stackexchange.com/a/560105
-- 3. https://tex.stackexchange.com/a/662126

function include_entries(directory)
    -- Initialise table (i.e. Lua dictionary) to hold journal files
    local files = {}

    -- Iterate over every file in the filetree in directory (which is entries/)
    for file in lfs.dir(directory) do
        fullpath = directory .."/".. file

        -- We will double-check that the object is a file
        modeAttr = lfs.attributes(fullpath, "mode")

        -- Retrieve the file extension (e.g: .tex, .txt)
        extension = string.sub(file,#file-3,#file)

        -- If it is a valid .tex file, we add it to the file table
        if modeAttr == "file" and extension == ".tex" then
            files[#files + 1] = file
        end
    end

    -- Once the files table is populated, we must sort it in order of the dates
    table.sort(files)

    -- Now we begin processing and adding these files into the LaTeX document.

    -- Initialise counter to keep track of the start of new months
    past_month = 0

    -- For every indexed index-file pair (i.e. ipair) in files:
    for index, file in ipairs(files) do
        fullpath = directory .. "/" .. file

        -- The filename WITHOUT the .tex extension (e.g: 2022-11-09)
        basename = string.sub(file, 1, #file-4)

        -- Retrieve the year, month, and day as integers
        year  = tonumber(string.sub(basename, 1,  4))
        month = tonumber(string.sub(basename, 6,  7))
        day   = tonumber(string.sub(basename, 9, 10))

        -- If the entry in question belongs to a new month, create a \part
        if month > past_month then
            -- We make sure to pass \part to the datetime2 macro so that it
            -- is given a proper English name (e.g. January). Note that we
            -- are using the English language-specific macro, because the
            -- generic macro is robust and cannot be expended in a PDFString,
            -- which means it will not work properly in our hyperref bookmarks:
            --
            -- For more info, see:
            -- https://tex.stackexchange.com/a/662126

            tex.sprint("\\part{ \\DTMenglishmonthname{" .. month .. "}}")
        end
        past_month = month

        -- Save the date of the current entry as a named DTM variable, because
        -- we cannot use it directly in \DTMdisplaydate without calculating a
        -- dow (day of week). This is because \DTMdisplaydate is also robust,
        -- and will not expand properly in a PDFString. By saving it first as a
        -- named entry, the dow is calculated automatically, bypassing this
        -- issue.
        --
        -- datetime2 package manual, section 3: Displaying the Date and Time
        tex.sprint("\\DTMsavedate{entry}{" .. basename .. "}")

        -- Note: template/formatting.tex and every chapter short-title depends
        --       on the availability of \DTMusedate{entry}

        -- Finally, include the file
        tex.sprint("\\include{" .. fullpath .. "}")
    end
end

include_entries("entries")