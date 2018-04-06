<%
Class Dotenv
    ' Based on concept III. Config - The Twelve-Factor App
    ' https://12factor.net/config

    Private IniFileDictionary

    Private Sub class_Initialize()
        Set IniFileDictionary = CreateObject("Scripting.Dictionary")
	End Sub

    ' @link http://www.4guysfromrolla.com/webtech/011999-1.shtml
    Public Sub IniFileLoad(ByVal FilSpc)
        IniFileDictionary.RemoveAll
        FilSpc = lcase(FilSpc)
        if left(FilSpc, 1) = "p" then
            'Physical path
            PhyPth = mid(FilSpc, instr(FilSpc, "=") + 1)
        else
            'Virtual path
            PhyPth = Server.MapPath(mid(FilSpc, instr(FilSpc, "=") + 1))
        end if

        set FilSys = CreateObject("Scripting.FileSystemObject")
        set IniFil = FilSys.OpenTextFile(PhyPth, 1)
        do while not IniFil.AtEndOfStream
            StrBuf = IniFil.ReadLine
            if StrBuf <> "" then
            'There is data on this line
            if left(StrBuf, 1) <> ";" then
                'It's not a comment
                if left(StrBuf, 1) = "[" then
                'It's a section header
                HdrBuf = mid(StrBuf, 2, len(StrBuf) - 2)
                else
                'It's a value
                StrPtr = instr(StrBuf, "=")
                AltBuf = lcase(HdrBuf & "|" & left(StrBuf, StrPtr - 1))
                do while IniFileDictionary.Exists(AltBuf)
                    AltBuf = AltBuf & "_"
                loop
                IniFileDictionary.Add AltBuf, mid(StrBuf, StrPtr + 1)
                end if
            end if
            end if
        loop
        IniFil.Close
        set IniFil = nothing
        set FilSys = nothing
    End Sub

    ' @link http://www.4guysfromrolla.com/webtech/011999-1.shtml
    Private Function IniFileValue(ByVal ValSpc)
        dim ifarray
        StrPtr = instr(ValSpc, "|")
        ValSpc = lcase(ValSpc)
        if StrPtr = 0 then
            'They want the whole section
            StrBuf = ""
            StrPtr = len(ValSpc) + 1
            ValSpc = ValSpc + "|"
            ifarray = IniFileDictionary.Keys
            for i = 0 to IniFileDictionary.Count - 1
            if left(ifarray(i), StrPtr) = ValSpc then
                'This is from the section
                if StrBuf <> "" then
                StrBuf = StrBuf & "~"
                end if
                StrBuf = StrBuf & ifarray(i) & "=" & IniFileDictionary(ifarray(i))
            end if
            next
        else
            'They want a specific value
            StrBuf = IniFileDictionary(ValSpc)
        end if
        IniFileValue = StrBuf
    End Function

    Public Property Get getenv(key) 
        getenv = IniFileValue("|" & key)
	End Property

End Class

%>
