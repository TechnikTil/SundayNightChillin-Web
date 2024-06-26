#if (!display && SNC_DEV_BUILD)
package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

class DevValues
{
    public static macro function buildNum():ExprOf<Float>
    {
        return macro $v{Context.definedValue('SNC_DEV_BUILD')};
    }
}
#end