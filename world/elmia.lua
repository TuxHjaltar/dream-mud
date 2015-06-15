return
{
	d2 = Room.new(
		"D2",
		{
			"d_gang"
		},
		function() return "Du tränger dig in mellan D2 och D3 och ser den vackraste midsommarstången i ditt liv." end,
		function() return "Du lämnar motvilligt midsommarstången bakom dig." end),
	d3 = Room.new(
		"D3",
		{
			"d_gang"
		}),
	d_gang = Room.new(
		"Gången i D-hallen",
		{
			"d2", "d3"
		},
		function(self, from) return "Du går ut i gången i D-hallen." .. from ~= "d2" and " En midsommarstång skymtar i bakgrunden." or "" end)
}
