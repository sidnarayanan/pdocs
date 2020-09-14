## Define mini-templates for each portion of the doco.

<%def name="h4(s)">#### ${s}
</%def>

<%def name="function(func)" buffered="True">
    <%
        returns = func.return_annotation()
        if returns:
            returns = ' -> ' + returns
    %>
${"#### " + func.name}

```python3
def ${func.name}(
    ${",\n    ".join(func.params())}
)${returns}
```
% if hasattr(func, 'parsed_docstring') and func.parsed_docstring:
    # table with arguments info
    % if func.parsed_docstring.params:
| Parameter | type | description | default |
|---|---|---|---|
        % for p in func.parsed_docstring.params:
| ${p.arg_name} | ${p.type_name} | ${p.description} | ${p.default} |
        % endfor
    % endif
% else:
${func.docstring}
% endif

% if show_source_code and func.source:

??? example "View Source"
        ${"\n        ".join(func.source)}

% endif
</%def>

<%def name="variable(var)" buffered="True">
```python3
${var.name}
```
% if hasattr(var, 'parsed_docstring') and var.parsed_docstring:
    # table with arguments info
    % if var.parsed_docstring.params:
| Parameter | type | description | default |
|---|---|---|---|
        % for p in var.parsed_docstring.params:
| ${p.arg_name} | ${p.type_name} | ${p.description} | ${p.default} |
        % endfor
    % endif
% else:
${var.docstring}
% endif

</%def>

<%def name="class_(cls)" buffered="True">
${"### " + cls.name}

```python3
class ${cls.name}(
    ${",\n    ".join(cls.params())}
)
```

% if hasattr(cls, 'parsed_docstring') and cls.parsed_docsting:
    # table with arguments info
    % if cls.parsed_docstring.params:
| Parameter | type | description | default |
|---|---|---|---|
        % for p in cls.parsed_docstring.params:
| ${p.arg_name} | ${p.type_name} | ${p.description} | ${p.default} |
        % endfor
    % endif
% else:
${cls.docstring}
% endif

% if show_source_code and cls.source:

??? example "View Source"
        ${"\n        ".join(cls.source)}

------

% endif

<%
  class_vars = cls.class_variables()
  static_methods = cls.functions()
  inst_vars = cls.instance_variables()
  methods = cls.methods()
  mro = cls.mro()
  subclasses = cls.subclasses()
%>
% if mro:
${h4('Ancestors (in MRO)')}
    % for c in mro:
* ${c.refname}
    % endfor
% endif

% if subclasses:
${h4('Descendants')}
    % for c in subclasses:
* ${c.refname}
    % endfor
% endif

% if class_vars:
${h4('Class variables')}
    % for v in class_vars:
${variable(v)}

    % endfor
% endif

% if static_methods:
${h4('Static methods')}
    % for f in static_methods:
${function(f)}

    % endfor
% endif

% if inst_vars:
${h4('Instance variables')}
% for v in inst_vars:
${variable(v)}

% endfor
% endif
% if methods:
${h4('Methods')}
% for m in methods:
${function(m)}

% endfor
% endif

</%def>

## Start the output logic for an entire module.

<%
  variables = module.variables()
  classes = module.classes()
  functions = module.functions()
  submodules = module.submodules
  heading = 'Namespace' if module.is_namespace else 'Module'
%>

${heading} ${module.name}
=${'=' * (len(module.name) + len(heading))}
${module.docstring}

% if show_source_code and module.source:

??? example "View Source"
        ${"\n        ".join(module.source)}

% endif

% if submodules:
Sub-modules
-----------
    % for m in submodules:
* [${m.name}](${m.name.split(".")[-1]}/)
    % endfor
% endif

% if variables:
Variables
---------
    % for v in variables:
${variable(v)}

    % endfor
% endif

% if functions:
Functions
---------
    % for f in functions:
${function(f)}

    % endfor
% endif

% if classes:
Classes
-------
    % for c in classes:
${class_(c)}

    % endfor
% endif
