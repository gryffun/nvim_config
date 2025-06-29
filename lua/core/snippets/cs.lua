local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- Helper function to get filename without extension
local function get_filename_base()
    return vim.fn.expand("%:t:r")
end

-- Common snippet templates
local mono_behavior_template = [[
using UnityEngine;

public class {className} : MonoBehaviour
{{
    {cursor}
}}
]]

local scriptable_object_template = [[
using UnityEngine;

[CreateAssetMenu(fileName = "{fileName}", menuName = "{menuName}", order = {order})]
public class {className} : ScriptableObject
{{
    {cursor}
}}
]]

-- Unity C# Snippets
return {
    -- ======================
    -- CLASS TEMPLATES
    -- ======================
    s("mono", fmt(mono_behavior_template, {
        className = f(get_filename_base),
        cursor = i(0)
    })),

    s("scriptable", fmt(scriptable_object_template, {
        fileName = i(1, "NewScriptableObject"),
        menuName = i(2, "ScriptableObjects/New Scriptable Object"),
        order = i(3, "0"),
        className = f(get_filename_base),
        cursor = i(0)
    })),

    s("editor", {
        t({"using UnityEngine;", "using UnityEditor;", ""}),
        t("[CustomEditor(typeof("), i(1, "Component"), t("))]"),
        t({"", "public class "}), f(get_filename_base),
        t({" : Editor", "{",
          "\tpublic override void OnInspectorGUI() {",
          "\t\tbase.OnInspectorGUI();",
          "\t\t"}),
        i(0),
        t({"", "\t}", "}"})
    }),

    s("interface", {
        t("public interface "), f(get_filename_base),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("struct", {
        t("public struct "), f(get_filename_base),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("enum", {
        t("public enum "), f(get_filename_base),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    -- ======================
    -- LIFECYCLE METHODS
    -- ======================
    s("init", {
        c(1, {
            t("private void Awake()"),
            t("private void Start()"),
            t("private void OnEnable()")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("update", {
        c(1, {
            t("private void Update()"),
            t("private void FixedUpdate()"),
            t("private void LateUpdate()")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("cleanup", {
        c(1, {
            t("private void OnDisable()"),
            t("private void OnDestroy()")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    -- ======================
    -- PHYSICS & COLLISIONS
    -- ======================
    s("collision", {
        c(1, {
            t("private void OnCollisionEnter(Collision other)"),
            t("private void OnCollisionStay(Collision other)"),
            t("private void OnCollisionExit(Collision other)"),
            t("private void OnCollisionEnter2D(Collision2D other)"),
            t("private void OnCollisionStay2D(Collision2D other)"),
            t("private void OnCollisionExit2D(Collision2D other)")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("trigger", {
        c(1, {
            t("private void OnTriggerEnter(Collider other)"),
            t("private void OnTriggerStay(Collider other)"),
            t("private void OnTriggerExit(Collider other)"),
            t("private void OnTriggerEnter2D(Collider2D other)"),
            t("private void OnTriggerStay2D(Collider2D other)"),
            t("private void OnTriggerExit2D(Collider2D other)")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    -- ======================
    -- INPUT & EVENTS
    -- ======================
    s("mouse", {
        c(1, {
            t("private void OnMouseDown()"),
            t("private void OnMouseUp()"),
            t("private void OnMouseEnter()"),
            t("private void OnMouseExit()"),
            t("private void OnMouseOver()"),
            t("private void OnMouseDrag()"),
            t("private void OnMouseUpAsButton()")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("input", {
        t("private void "),
        c(1, {
            t("OnMove"),
            t("OnLook"),
            t("OnFire"),
            t("OnJump"),
            t("OnSubmit"),
            t("OnCancel")
        }),
        t("(UnityEngine.InputSystem.InputAction.CallbackContext context)"),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    -- ======================
    -- UI & RENDERING
    -- ======================
    s("ui", {
        c(1, {
            t("private void OnPointerClick(PointerEventData eventData)"),
            t("private void OnPointerEnter(PointerEventData eventData)"),
            t("private void OnPointerExit(PointerEventData eventData)"),
            t("private void OnPointerDown(PointerEventData eventData)"),
            t("private void OnPointerUp(PointerEventData eventData)"),
            t("private void OnDrag(PointerEventData eventData)"),
            t("private void OnDrop(PointerEventData eventData)")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("render", {
        c(1, {
            t("private void OnBecameVisible()"),
            t("private void OnBecameInvisible()"),
            t("private void OnPreRender()"),
            t("private void OnPostRender()"),
            t("private void OnRenderObject()"),
            t("private void OnWillRenderObject()")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("gizmo", {
        c(1, {
            t("private void OnDrawGizmos()"),
            t("private void OnDrawGizmosSelected()")
        }),
        t({" {", "\t"}),
        i(0),
        t({"", "}"})
    }),

    -- ======================
    -- COROUTINES & TIMING
    -- ======================
    s("coroutine", {
        t({"private IEnumerator "}), i(1, "CoroutineName"), t("() {"),
        t({"", "\t"}),
        i(0),
        t({"", "\tyield return null;", "}"})
    }),

    s("invoke", {
        t("Invoke(nameof("), i(1, "MethodName"), t("), "), i(2, "delay"), t(");")
    }),

    s("invokerepeat", {
        t("InvokeRepeating(nameof("), i(1, "MethodName"), t("), "),
        i(2, "initialDelay"), t(", "), i(3, "repeatRate"), t(");")
    }),

    -- ======================
    -- DEBUGGING & LOGGING
    -- ======================
    s("log", {
        t("Debug.Log("), i(1, "\"Message\""), t(");")
    }),

    s("logwarn", {
        t("Debug.LogWarning("), i(1, "\"Warning\""), t(");")
    }),

    s("logerr", {
        t("Debug.LogError("), i(1, "\"Error\""), t(");")
    }),

    s("assert", {
        t("Debug.Assert("), i(1, "condition"), t(", "), i(2, "\"Message\""), t(");")
    }),

    s("breakpoint", {
        t("System.Diagnostics.Debugger.Break();")
    }),

    -- ======================
    -- COMMON PATTERNS
    -- ======================
    s("getcomp", {
        t("GetComponent<"), i(1, "ComponentType"), t(">();")
    }),

    s("getcompchild", {
        t("GetComponentInChildren<"), i(1, "ComponentType"), t(">();")
    }),

    s("getcompparent", {
        t("GetComponentInParent<"), i(1, "ComponentType"), t(">();")
    }),

    s("/*-------*/", {
        t("/*----------------------------------------------------------------------------*/"),
    }),

    s("addcomp", {
        t("gameObject.AddComponent<"), i(1, "ComponentType"), t(">();")
    }),

    s("findobj", {
        t("FindObjectOfType<"), i(1, "ObjectType"), t(">();")
    }),

    s("instantiate", {
        t("Instantiate("), i(1, "prefab"), t(", "), i(2, "position"), t(", "), i(3, "rotation"), t(");")
    }),

    s("destroy", {
        t("Destroy("), i(1, "gameObject"), t(");")
    }),

    s("destroy", {
        t("Destroy("), i(1, "gameObject"), t(", "), i(2, "delay"), t(");")
    }),

    -- ======================
    -- ATTRIBUTES
    -- ======================
    s("attr", {
        t("["), i(1, "AttributeName"), t("]")
    }),

    s("serialize", {
        t("[SerializeField] private "), i(1, "variableType"), t(" "), i(2, "_variableName"), t(";")
    }),

    s("range", {
        t("[Range("), i(1, "min"), t(", "), i(2, "max"), t(")]")
    }),

    s("tooltip", {
        t("[Tooltip(\""), i(1, "Tooltip text"), t("\")]")
    }),

    s("require", {
        t("[RequireComponent(typeof("), i(1, "ComponentType"), t("))]")
    }),

    s("header", {
        t("[Header(\""), i(1, "Header text"), t("\")]")
    }),

    s("space", {
        t("[Space("), i(1, "10"), t(")]")
    }),

    -- ======================
    -- NEWTONSOFT JSON
    -- ======================
    s("json", {
        t("using Newtonsoft.Json;")
    }),

    s("jsonprop", {
        t("[JsonProperty(\""), i(1, "propertyName"), t("\")]")
    }),

    -- ======================
    -- UNITY MATHEMATICS
    -- ======================
    s("v3", {
        t("Vector3("), i(1, "0"), t("f, "), i(2, "0"), t("f, "), i(3, "0"), t("f)")
    }),

    s("v2", {
        t("Vector2("), i(1, "0"), t("f, "), i(2, "0"), t("f)")
    }),

    s("quat", {
        t("Quaternion.Euler("), i(1, "0"), t("f, "), i(2, "0"), t("f, "), i(3, "0"), t("f)")
    }),

    s("lerp", {
        t("Mathf.Lerp("), i(1, "a"), t(", "), i(2, "b"), t(", "), i(3, "t"), t(");")
    }),

    s("slerp", {
        t("Vector3.Slerp("), i(1, "a"), t(", "), i(2, "b"), t(", "), i(3, "t"), t(");")
    }),

    -- ======================
    -- EDITOR UTILITIES
    -- ======================
    s("menuitem", {
        t("[MenuItem(\""), i(1, "Menu/Path"), t("\")]"),
        t({"", "private static void "}), i(2, "MethodName"), t("() {"),
        t({"", "\t"}),
        i(0),
        t({"", "}"})
    }),

    s("context", {
        t("[ContextMenu(\""), i(1, "Menu Item"), t("\")]"),
        t({"", "private void "}), i(2, "MethodName"), t("() {"),
        t({"", "\t"}),
        i(0),
        t({"", "}"})
    }),
}
