/* Copyright 2014 Nicolas Laplante
*
* This file is part of envelope.
*
* envelope is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* envelope is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with envelope. If not, see http://www.gnu.org/licenses/.
*/

using Envelope.DB;
using Envelope.Dialog;
using Envelope.Widget;

namespace Envelope.View {

    private static BudgetOverview budget_overview_instance = null;

    private static const string STYLE_CLASS_OVERVIEW_TITLE = ".overview-title { color: alpha(#333, 0.8); font: open sans 36px; }";
    private static const string STYLE_CLASS_OVERVIEW = ".overview { color: alpha(#333, 0.8); font: open sans light 18px; }";
    private static const string STYLE_CLASS_INFLOW = ".inflow { font-weight: 900; font-size: 18px; color: #4e9a06; }";
    private static const string STYLE_CLASS_OUTFLOW = ".outflow { font-weight: 900; font-size: 18px; color: #A62626; }";

    public class BudgetOverview : Gtk.Box {

        public static new unowned BudgetOverview get_default () {
            if (budget_overview_instance == null) {
                budget_overview_instance = new BudgetOverview ();
            }

            return budget_overview_instance;
        }

        public Budget budget { get; set; }

        private BudgetOverview () {
            Object (orientation: Gtk.Orientation.VERTICAL);
            budget_overview_instance = this;

            build_ui ();
            connect_signals ();
        }

        private void build_ui () {

            homogeneous = true;

            build_summary_ui ();
            build_top_categories_ui ();
        }

        private void build_summary_ui () {

            var summary_container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            set_class (summary_container, Granite.StyleClass.CONTENT_VIEW);
            pack_start (summary_container);

            var summary_title = new Gtk.Label(_("Your budget right now:"));
            set_class (summary_title, Granite.StyleClass.H1_TEXT);
            Granite.Widgets.Utils.set_theming (summary_title, STYLE_CLASS_OVERVIEW_TITLE, "overview-title", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            summary_container.pack_start (summary_title);

            // Show horitonzal box with this month's inflow and outflow
            var in_out_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            summary_container.pack_start (in_out_box);

            var inflow_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            in_out_box.pack_start (inflow_box);

            var inflow_label = new Gtk.Label (_("Inflow:"));
            set_class (inflow_label, Granite.StyleClass.H2_TEXT);
            Granite.Widgets.Utils.set_theming (inflow_label, STYLE_CLASS_OVERVIEW, "overview", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            inflow_box.pack_start (inflow_label, false);

            var inflow_value_label = new Gtk.Label (Envelope.Util.format_currency(4910.23d));
            Granite.Widgets.Utils.set_theming (inflow_value_label, STYLE_CLASS_INFLOW, "inflow", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            inflow_box.pack_start (inflow_value_label, false);

            var outflow_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            in_out_box.pack_start (outflow_box);

            var outflow_label = new Gtk.Label (_("Outflow:"));
            set_class (outflow_label, Granite.StyleClass.H2_TEXT);
            Granite.Widgets.Utils.set_theming (outflow_label, STYLE_CLASS_OVERVIEW, "overview", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            outflow_box.pack_start (outflow_label, false);

            var outflow_value_label = new Gtk.Label (Envelope.Util.format_currency(4192.88d));
            Granite.Widgets.Utils.set_theming (outflow_value_label, STYLE_CLASS_OUTFLOW, "outflow", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            outflow_box.pack_start (outflow_value_label, false);

            var remaining_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            in_out_box.pack_start (remaining_box);

            var remaining_label = new Gtk.Label (_("Remaining this month:"));
            set_class (remaining_label, Granite.StyleClass.H2_TEXT);
            Granite.Widgets.Utils.set_theming (remaining_label, STYLE_CLASS_OVERVIEW, "overview", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            remaining_box.pack_start (remaining_label, false);

            var remaining_value_label = new Gtk.Label (Envelope.Util.format_currency(788.19d));
            Granite.Widgets.Utils.set_theming (remaining_value_label, STYLE_CLASS_OUTFLOW, "outflow", Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            remaining_box.pack_start (remaining_value_label, false);
        }

        private void build_top_categories_ui () {

            var categories_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            pack_start (categories_container);

            var categories_container_ctx = categories_container.get_style_context ();
            categories_container_ctx.add_class (Granite.StyleClass.CONTENT_VIEW);
            set_class (categories_container, Granite.StyleClass.SOURCE_LIST);

        }

        private void connect_signals () {
            notify["budget"].connect (budget_changed);
        }

        private void budget_changed () {

        }

        private static void set_class (Gtk.Widget widget, string style_class) {
            var style_ctx = widget.get_style_context ();
            style_ctx.add_class (style_class);
        }
    }
}