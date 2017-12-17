---
layout: post
title:  Dynamic BoundColumns in Code Behind
date:   2005-07-30 19:28:54
tags:   c_sharp dotnet
---
I've been dragged into .NET programming kicking and screaming. Since you're on this page, I'll assume that you're in the same boat. Welcome to the Good Ship Lollipop.

## Problem:

Let's imagine that you have a large dataset. Let's now imagine that you are not Microsoft's expected user and you have, say, 100 columns in your dataset. Row paging is great, but what are we going to do with all those columns? We could display them all, but that would be ugly.

What we need is something along the lines of "column paging". The way most people know of declaring their columns is to edit the <columns> block in their asp control in the actual .aspx file.

```
<asp:DataGrid ID="DefaultGrid" Runat="server" AutoGenerateColumns=False>
<Columns>
<asp:BoundColumn DataField="Index" ReadOnly=True HeaderText="#">
</asp:BoundColumn>
<asp:HyperLinkColumn DataNavigateUrlField="Hyperlink"
DataTextField="Title" HeaderText="Title">
</asp:HyperLinkColumn>
<asp:BoundColumn DataField="Description"
ReadOnly=True HeaderText="Description">
</asp:BoundColumn>
</Columns>
</asp:DataGrid>
```

This isn't particularly efficient if we want things to be automated though, is it?

## Solution:

What we really want to do here is define which columns are bound in our code behind files. Doesn't that sound like a good idea? Yes. It does.

```
private void InitializeBoundColumns()
{
   DefaultGrid.AutoGenerateColumns = false;
   BoundColumn indexCol = new BoundColumn();
   indexCol.DataField = "Index";
   indexCol.HeaderText = "#";

   BoundColumn descCol = new BoundColumn();
   descCol.DataField = "Description";
   descCol.HeaderText = "Description";

   HyperLinkColumn urlCol = new HyperLinkColumn();
   urlCol.DataTextField = "Title";
   urlCol.DataNavigateUrlField = "Hyperlink";
   urlCol.HeaderText = "Title";

   // Add three columns to collection.
   DefaultGrid.Columns.Add(indexCol);
   DefaultGrid.Columns.Add(urlCol);
   DefaultGrid.Columns.Add(descCol);
}  
```

## References:
* [http://www.netomatix.com/DGAutoGen.aspx](//www.netomatix.com/DGAutoGen.aspx)
