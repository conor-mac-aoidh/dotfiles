-- Kendo UI Documentation Quick Access
-- Add this to your init.lua or appropriate config file

-- Component type mapping based on screenshots
local kendo_component_types = {
  -- Barcodes
  ["Barcode"] = "barcodes",
  ["QRCode"] = "barcodes",
  ["Barcode1D"] = "barcodes",
  ["Barcode2D"] = "barcodes",
  
  -- Buttons
  ["Button"] = "buttons",
  ["ButtonGroup"] = "buttons",
  ["ButtonsCollection"] = "buttons",
  ["FloatingActionButton"] = "buttons",
  ["SplitButton"] = "buttons",
  ["DropDownButton"] = "buttons",
  
  -- Chips
  ["Chip"] = "layout",
  ["ChipList"] = "layout",
  
  -- Charts
  ["Chart"] = "charts",
  ["ChartWizard"] = "charts",
  
  -- Conversational UI
  ["Chat"] = "conversational-ui",
  ["Message"] = "conversational-ui",
  
  -- Data Query
  ["DataQuery"] = "data-query",
  ["Filter"] = "filter",
  
  -- Date Inputs
  ["DatePicker"] = "dateinputs",
  ["DateInput"] = "dateinputs",
  ["DateRangePicker"] = "dateinputs",
  ["DateTimePicker"] = "dateinputs",
  ["TimePicker"] = "dateinputs",
  ["Calendar"] = "dateinputs",
  ["MultiViewCalendar"] = "dateinputs",
  
  -- Date Math
  ["DateMath"] = "datemath",
  
  -- Dialogs
  ["Dialog"] = "dialogs",
  ["Window"] = "dialogs",
  ["Popup"] = "popup",
  
  -- Drawing
  ["Drawing"] = "drawing",
  
  -- Dropdowns
  ["DropDown"] = "dropdowns",
  ["DropDownList"] = "dropdowns",
  ["ComboBox"] = "dropdowns",
  ["AutoComplete"] = "dropdowns",
  ["MultiSelect"] = "dropdowns",
  
  -- Editor
  ["Editor"] = "editor",
  
  -- Excel Export
  ["ExcelExport"] = "excel-export",
  
  -- File Saver
  ["FileSaver"] = "file-saver",
  
  -- Gantt
  ["Gantt"] = "gantt",
  
  -- Gauges
  ["Gauge"] = "gauges",
  ["LinearGauge"] = "gauges",
  ["RadialGauge"] = "gauges",
  ["ArcGauge"] = "gauges",
  
  -- Grid
  ["Grid"] = "grid",
  ["PivotGrid"] = "pivotgrid",
  ["TreeList"] = "treelist",
  ["SpreadSheet"] = "spreadsheet",
  
  -- Icons
  ["Icon"] = "icons",
  ["IconRegistry"] = "icons",
  
  -- Indicators
  ["Indicator"] = "indicators",
  ["LoadingIndicator"] = "indicators",
  ["Skeleton"] = "indicators",
  
  -- Inputs
  ["Input"] = "inputs",
  ["Textbox"] = "inputs",
  ["TextBox"] = "inputs",
  ["TextBoxComponent"] = "inputs",
  ["NumericTextBox"] = "inputs",
  ["NumericTextBoxComponent"] = "inputs",
  ["MaskedTextBox"] = "inputs",
  ["MaskedTextBoxComponent"] = "inputs",
  ["Switch"] = "inputs",
  ["SwitchComponent"] = "inputs",
  ["Slider"] = "inputs",
  ["SliderComponent"] = "inputs",
  ["RangeSlider"] = "inputs",
  ["RangeSliderComponent"] = "inputs",
  ["Checkbox"] = "inputs",
  ["CheckboxComponent"] = "inputs",
  ["RadioButton"] = "inputs",
  ["RadioButtonComponent"] = "inputs",
  ["Rating"] = "inputs",
  ["RatingComponent"] = "inputs",
  ["ColorPicker"] = "inputs",
  ["ColorPickerComponent"] = "inputs",
  ["ColorGradient"] = "inputs",
  ["ColorGradientComponent"] = "inputs",
  
  -- Labels
  ["Label"] = "labels",
  ["FloatingLabel"] = "labels",
  
  -- Layout
  ["Layout"] = "layout",
  ["Card"] = "layout",
  ["ExpansionPanel"] = "layout",
  ["Splitter"] = "layout",
  ["TabStrip"] = "layout",
  ["PanelBar"] = "layout",
  ["Stepper"] = "layout",
  ["TileLayout"] = "layout",
  ["StackLayout"] = "layout",
  
  -- ListView and ListBox
  ["ListView"] = "listview",
  ["ListBox"] = "listbox",
  
  -- Map
  ["Map"] = "map",
  
  -- Menus
  ["Menu"] = "menus",
  ["ContextMenu"] = "menus",
  
  -- Navigation
  ["Navigation"] = "navigation",
  ["Breadcrumb"] = "navigation",
  ["ScrollView"] = "scrollview",
  
  -- Notification
  ["Notification"] = "notification",
  ["Toast"] = "notification",
  ["Alert"] = "notification",
  
  -- Pager
  ["Pager"] = "pager",
  
  -- PDF Export
  ["PDFExport"] = "pdf-export",
  ["PDFViewer"] = "pdfviewer",
  
  -- ProgressBars
  ["ProgressBar"] = "progressbars",
  ["ProgressButton"] = "progressbars",
  
  -- Ripple
  ["Ripple"] = "ripple",
  
  -- Scheduler
  ["Scheduler"] = "scheduler",
  ["Calendar"] = "scheduler",
  ["Agenda"] = "scheduler",
  
  -- Sortable
  ["Sortable"] = "sortable",
  ["Draggable"] = "sortable",
  ["Droppable"] = "sortable",
  
  -- ToolBar
  ["ToolBar"] = "toolbar",
  
  -- Tooltips
  ["Tooltip"] = "tooltips",
  
  -- TreeView
  ["TreeView"] = "treeview",
  
  -- Typography
  ["Typography"] = "typography",
  
  -- Uploads
  ["Upload"] = "uploads",
  ["FileSelect"] = "uploads",
  
  -- Utilities
  ["FX"] = "utilities",
  ["Globalization"] = "globalization",
  ["DOMUtils"] = "utilities",
  ["Responsive"] = "utilities",
}

-- Function to get component type based on component name
local function get_component_type(component_name)
  -- Try direct match first
  if kendo_component_types[component_name] then
    return kendo_component_types[component_name]
  end
  
  -- Try to match by prefix (removes 'Component' suffix)
  local base_name = component_name:gsub("Component$", "")
  if kendo_component_types[base_name] then
    return kendo_component_types[base_name]
  end
  
  -- Add verbose logging to help debug
  vim.notify("Trying to find component type for: " .. component_name, vim.log.levels.DEBUG)
  
  -- Default fallback
  return "components"
end

-- Function to open Kendo documentation
function open_kendo_docs()
  -- Get word under cursor
  local cword = vim.fn.expand("<cword>")
  
  -- Extract component type
  local component_type = get_component_type(cword)
  
  -- Build URL
  local url = "https://www.telerik.com/kendo-angular-ui/components/" .. component_type .. "/api/" .. cword
  
  -- Add debug info
  vim.notify("Component: " .. cword .. ", Type: " .. component_type, vim.log.levels.INFO)
  
  -- Open in browser (works on macOS and Linux)
  local open_cmd = vim.fn.has('mac') == 1 and "open" or "xdg-open"
  vim.fn.system(open_cmd .. " '" .. url .. "'")
  
  vim.notify("Opening Kendo docs: " .. url, vim.log.levels.INFO)
end

-- Key mapping
vim.keymap.set('n', '<leader>kd', open_kendo_docs, { noremap = true, desc = "Open Kendo Docs" })

-- Add to command palette
vim.api.nvim_create_user_command('KendoDocs', open_kendo_docs, { desc = "Open Kendo UI documentation for component under cursor" })
