<HandleError()> _
Public Class HomeController
    Inherits FantasyFootballWeb.BaseController

    Function Index() As ActionResult
        Dim model As New HomeModel

        'years list
        Dim i As Integer = Date.Today.Year
        Do While i >= Date.Today.Year - 2
            model.YearsList.Add(i)
            i -= 1
        Loop

        'league list
        model.LeaguesList.Add(New HomeModel.League() With {.LeagueId = 1, .Name = "PA Fantasy"})
        model.LeaguesList.Add(New HomeModel.League() With {.LeagueId = 2, .Name = "What's Your Fantasy Football"})


        Return View(model)
    End Function

End Class
