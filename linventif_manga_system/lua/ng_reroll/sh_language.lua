local languages = {}

// -- // -- // -- // -- // -- // -- // -- //
// DO NOT EDIT ABOVE THIS LINE
// -- // -- // -- // -- // -- // -- // -- //

languages["french"] = {}

// -- // -- // -- // -- // -- // -- // -- //
// DO NOT EDIT BELOW THIS LINE
// -- // -- // -- // -- // -- // -- // -- //

function NGReroll.GetTranslation(id)
    return languages[NGReroll.Config.Language][id] or "ERROR"
end