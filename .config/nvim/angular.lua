local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- Angular Component
s({trig = "ngcomp", dscr = "Angular Component"},
  fmt(
    [[
    import {{ Component }} from '@angular/core';

    @Component({{
      selector: '{1}',
      standalone: true,
      imports: [],
      template: `
        {2}
      `,
      styles: [`
        {3}
      `]
    }})
    export class {4} {{
      {5}
    }}
    ]],
    {
      i(1, "my-component"),
      i(2),
      i(3),
      i(4, "MyComponent"),
      i(0),
    }
  )
)

-- Angular Directive
s({trig = "ngdir", dscr = "Angular Directive"},
  fmt(
    [[
    import {{ Directive }} from '@angular/core';

    @Directive({{
      selector: '{1}'
    }})
    export class {2} {{
      constructor() {{
        {3}
      }}
    }}
    ]],
    {
      i(1, "[myDirective]"),
      i(2, "MyDirective"),
      i(0),
    }
  )
)

-- Angular Service
s({trig = "ngserv", dscr = "Angular Service"},
  fmt(
    [[
    import {{ Injectable }} from '@angular/core';

    @Injectable({{
      providedIn: 'root'
    }})
    export class {1} {{
      constructor() {{
        {2}
      }}
    }}
    ]],
    {
      i(1, "MyService"),
      i(0),
    }
  )
)

-- Angular Pipe
s({trig = "ngpipe", dscr = "Angular Pipe"},
  fmt(
    [[
    import {{ Pipe, PipeTransform }} from '@angular/core';

    @Pipe({{
      name: '{1}'
    }})
    export class {2} implements PipeTransform {{
      transform(value: any, ...args: any[]) {{
        {3}
      }}
    }}
    ]],
    {
      i(1, "myPipe"),
      i(2, "MyPipe"),
      i(0),
    }
  )
)

-- Jest Test
s({trig = "jest", dscr = "Jest Test"},
  fmt(
    [[
    import {{ {1} }} from './{2}';

    describe('{1}', () => {{
      let {3}: {1};

      beforeEach(() => {{
        {3} = new {1}();
      }});

      it('should create an instance', () => {{
        expect({3}).toBeTruthy();
      }});
    }});
    ]],
    {
      i(1, "MyComponent"),
      i(2, "my-component.component.ts"),
      i(3, "component"),
    }
  )
)

-- Angular Test with TestBed
s({trig = "ngtest", dscr = "Angular Test with TestBed"},
  fmt(
    [[
    import {{ ComponentFixture, TestBed }} from '@angular/core/testing';
    import {{ {1} }} from './{2}';

    describe('{1}', () => {{
      let component: {1};
      let fixture: ComponentFixture<{1}>;

      beforeEach(async () => {{
        await TestBed.configureTestingModule({{
          imports: [{1}],
        }}).compileComponents();

        fixture = TestBed.createComponent({1});
        component = fixture.componentInstance;
        fixture.detectChanges();
      }});

      it('should create', () => {{
        expect(component).toBeTruthy();
      }});
    }});
    ]],
    {
      i(1, "MyComponent"),
      i(2, "my-component.component.ts"),
    }
  )
)

-- NgRx Action
s({trig = "ngrxaction", dscr = "NgRx Action"},
  fmt(
    [[
    import {{ createAction, props }} from '@ngrx/store';

    export const {1} = createAction(
      '[{2}] {3}',
      props<{4}>()
    );
    ]],
    {
      i(1, "loadFoos"),
      i(2, "Foo"),
      i(3, "Load Foos"),
      i(4, "foos: Foo[]"),
    }
  )
)

-- NgRx Reducer
s({trig = "ngrxreducer", dscr = "NgRx Reducer"},
  fmt(
    [[
    import {{ createReducer, on }} from '@ngrx/store';
    import {{ {2} }} from './{3}';

    export const initialState: {1} = {{

    }};

    export const {4} = createReducer(
      initialState,
      on({2}, (state, {{ {5} }}) => ({{
        ...state,
        {6}: {5}
      }}))
    );
    ]],
    {
      i(1, "fooState"),
      i(2, "loadFoos"),
      i(3, "foo.actions.ts"),
      i(4, "fooReducer"),
      i(5, "foos"),
      i(6, "foos"),
    }
  )
)

-- NgRx Effect
s({trig = "ngrxeffect", dscr = "NgRx Effect"},
  fmt(
    [[
    import {{ Injectable }} from '@angular/core';
    import {{ Actions, createEffect, ofType }} from '@ngrx/effects';
    import {{ catchError, map, of, switchMap }} from 'rxjs';
    import {{ {1} }} from './{2}';
    import {{ {3} }} from './{4}';

    @Injectable()
    export class {5} {{
      constructor(private actions$: Actions, private {6}: {3}) {{}}

      {7}$ = createEffect(() =>
        this.actions$.pipe(
          ofType({1}),
          switchMap(() =>
            this.{6}.{8}().pipe(
              map(({9}) => ({10}({9}))),
              catchError(() => of({11}()))
            )
          )
        )
      );
    }}
    ]],
    {
      i(1, "loadFoos"),
      i(2, "foo.actions.ts"),
      i(3, "FooService"),
      i(4, "foo.service.ts"),
      i(5, "FooEffects"),
      i(6, "fooService"),
      i(7, "loadFoos"),
      i(8, "getFoos"),
      i(9, "foos"),
      i(10, "loadFoosSuccess"),
      i(11, "loadFoosFailure"),
    }
  )
)
