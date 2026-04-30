// ****************************************************************
//
// @project Moo Filter 1.1
// @author Sean Darrenkamp
// @date 5/15/2004
// @file sd_test_filter
// Copyright 2004 Sean Darrenkamp
//
// This code is licensed under the GPL for use. See the GNU.org
// site for more information.
//
// http://www.gnu.org/licenses/gpl.html
//
// ****************************************************************

#include "sd_filter_inc"

// Performs a test scan of an item.
void main()
{
    scan(GetFirstItemInInventory(OBJECT_SELF));
}
