package com.popover

import android.content.Context
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.PictureDrawable
import android.os.Build
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import android.widget.PopupWindow
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.graphics.toColorInt
import androidx.core.view.marginBottom
import com.caverock.androidsvg.SVG
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableType
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.UIManagerHelper
import com.google.android.flexbox.AlignItems.CENTER
import com.google.android.flexbox.FlexDirection
import com.google.android.flexbox.FlexboxLayout
import com.google.android.flexbox.FlexboxLayout.LayoutParams
import com.google.android.flexbox.FlexboxLayout.SHOW_DIVIDER_MIDDLE
import com.google.android.flexbox.JustifyContent.SPACE_BETWEEN

@ReactModule(name = PopoverModule.NAME)
class PopoverModule(reactContext: ReactApplicationContext) :
  NativePopoverSpec(reactContext) {
  private lateinit var popupWindow: PopupWindow
  private fun Int.dpToPx(context: Context): Int {
    val result = TypedValue.applyDimension(
      TypedValue.COMPLEX_UNIT_DIP,
      this.toFloat(),
      context.resources.displayMetrics
    ).toInt()
    return result
  }
  private fun loadSvgFromAssets(context: Context, fileName: String, widthPx: Int, heightPx: Int): Drawable? {
    return try {
      val inputStream = context.assets.open(fileName)
      val svg = SVG.getFromInputStream(inputStream)

      // 设置目标尺寸
      svg.setDocumentWidth(widthPx.toFloat())
      svg.setDocumentHeight(heightPx.toFloat())

      val picture = svg.renderToPicture()
      val drawable = PictureDrawable(picture)
      drawable
    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }
  data class PaddingDefaults(
    val top: Int,
    val left: Int,
    val bottom: Int,
    val right: Int
  )

  data class TextFontDefaults(
    val fontSize: Float,
    val fontWeight: Int
  )
  // 数据类定义
  data class ConfigDefaults(
    val menuWidth: Int,
    val menuCornerRadius: Float,
    val textColor: String,
    val backgroundColor: String,
    val borderColor: String,
    val borderWidth: Float,
    val padding: PaddingDefaults,
    val textFont: TextFontDefaults,
    val textAlignment: String,
    val animationDuration: Float,
    val rowHeight:Int,
    val selectedTextColor: String,
    val separatorColor: String,
    val shadowColor: String,
    val shadowOpacity: Float,
    val shadowRadius: Float,
    val shadowOffsetX: Float,
    val shadowOffsetY: Float,
    val checkIconSize:Int
  )
  // 安全读取方法
  private fun getSafeString(config: ReadableMap?, key: String): String? {
    return try {
      if (config?.hasKey(key) == true) {
        config.getString(key)
      } else {
        null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun getSafeDouble(config: ReadableMap?, key: String): Double? {
    return try {
      if (config?.hasKey(key) == true) {
        config.getDouble(key)
      } else {
        null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun getSafeInt(config: ReadableMap?, key: String): Int? {
    return try {
      if (config?.hasKey(key) == true) {
        config.getInt(key)
      } else {
        null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun getSafeMap(config: ReadableMap?, key: String): ReadableMap? {
    return try {
      if (config?.hasKey(key) == true) {
        config.getMap(key)
      } else {
        null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun getPaddingWithDefaults(paddingMap: ReadableMap?): PaddingDefaults {
    return if (paddingMap != null) {
      PaddingDefaults(
        top = getSafeDouble(paddingMap, "top")?.toInt() ?: 0,
        left = getSafeDouble(paddingMap, "left")?.toInt() ?: 16.dpToPx(reactApplicationContext),
        bottom = getSafeDouble(paddingMap, "bottom")?.toInt() ?: 0,
        right = getSafeDouble(paddingMap, "right")?.toInt() ?: 16.dpToPx(reactApplicationContext)
      )
    } else {
      PaddingDefaults(0, 16.dpToPx(reactApplicationContext), 0, 16.dpToPx(reactApplicationContext)) // 默认内边距
    }
  }

  private fun getTextFontWithDefaults(textFontMap: ReadableMap?): TextFontDefaults {
    return if (textFontMap != null) {
      TextFontDefaults(
        fontSize = getSafeDouble(textFontMap, "fontSize")?.toFloat() ?: 15f,
        fontWeight = getSafeDouble(textFontMap, "fontWeight")?.toInt() ?: 500
      )
    } else {
      TextFontDefaults(15f, 500) // 默认字体
    }
  }

  // 获取配置默认值
  private fun getConfigWithDefaults(config: ReadableMap?): ConfigDefaults {
    return ConfigDefaults(
      menuWidth = getSafeDouble(config, "menuWidth")?.toInt() ?: 160,
      menuCornerRadius = getSafeDouble(config, "menuCornerRadius")?.toFloat() ?: 16f,
      textColor = getSafeString(config, "textColor") ?: "#333333",
      backgroundColor = getSafeString(config, "backgroundColor") ?: "#FFFFFF",
      borderColor = getSafeString(config, "borderColor") ?: "#E5E5E5",
      borderWidth = getSafeDouble(config, "borderWidth")?.toFloat() ?: 0f,
      padding = getPaddingWithDefaults(getSafeMap(config, "padding")),
      textFont = getTextFontWithDefaults(getSafeMap(config, "textFont")),
      textAlignment = getSafeString(config, "textAlignment") ?: "left",
      animationDuration = getSafeDouble(config, "animationDuration")?.toFloat() ?: 0.2f,
      selectedTextColor = getSafeString(config, "selectedTextColor") ?: "#FF891F",
      separatorColor = getSafeString(config, "separatorColor") ?: "#E5E5E5",
      shadowColor = getSafeString(config, "shadowColor") ?: "#000000",
      shadowOpacity = getSafeDouble(config, "shadowOpacity")?.toFloat() ?: 0.1f,
      shadowRadius = getSafeDouble(config, "shadowRadius")?.toFloat() ?: 4f,
      shadowOffsetX = getSafeDouble(config, "shadowOffsetX")?.toFloat() ?: 0f,
      shadowOffsetY = getSafeDouble(config, "shadowOffsetY")?.toFloat() ?: 2f,
      rowHeight = getSafeInt(config,"rowHeight")?:48,
      checkIconSize = getSafeInt(config,"checkIconSize")?:16
    )
  }
  override fun getName(): String {
    return NAME
  }
  private fun ReadableArray.toStringList(): List<String> {
    val list = mutableListOf<String>()
    for (i in 0 until this.size()) {
      if (this.getType(i) == ReadableType.String) {
        list.add(this.getString(i) ?: "")
      }
    }
    return list
  }
  private fun findViewByIdTurbo(anchorViewId: Int, reactContext: ReactApplicationContext): View? {
    val uiManager= UIManagerHelper.getUIManagerForReactTag(reactContext,anchorViewId)
    return  uiManager?.resolveView(anchorViewId)
  }
  override fun show(
    anchorViewId: Double,
    menuItems: ReadableArray?,
    index: Double?,
    config: ReadableMap?,
    promise: Promise?
  ) {
    val configDefaults = getConfigWithDefaults(config)
    val selectIndex = index?.toInt()
    val activity = currentActivity ?: return
    activity.runOnUiThread{
      val anchorView = findViewByIdTurbo(anchorViewId.toInt(),reactApplicationContext)
      if(anchorView!=null){

        val popupLayout = FlexboxLayout(reactApplicationContext).apply {
          flexDirection = FlexDirection.COLUMN

          layoutParams = LayoutParams(
            LayoutParams.MATCH_PARENT,
            LayoutParams.WRAP_CONTENT
          )
          showDividerVertical=SHOW_DIVIDER_MIDDLE
          val divider = ContextCompat.getDrawable(context, R.drawable.divider_vertical)
          requireNotNull(divider) { "Divider drawable is null!" }
          setDividerDrawable(divider)
          val drawable = GradientDrawable().apply {
            setColor(configDefaults.backgroundColor.toColorInt())
            cornerRadius = configDefaults.menuCornerRadius
            // 添加边框
            if (configDefaults.borderWidth > 0) {
              setStroke(configDefaults.borderWidth.toInt(), configDefaults.borderColor.toColorInt())
            }
          }
          background = drawable
          justifyContent = SPACE_BETWEEN
          setPadding(
            configDefaults.padding.left,
            configDefaults.padding.top,
            configDefaults.padding.right,
            configDefaults.padding.bottom
          )
        }
        val itemList = menuItems?.toStringList()
        itemList?.forEachIndexed { index, title ->
          val container = FlexboxLayout(reactApplicationContext).apply {
            layoutParams = LayoutParams(
              LayoutParams.MATCH_PARENT,
              configDefaults.rowHeight.dpToPx(context)
            )
            alignItems = CENTER
            justifyContent =SPACE_BETWEEN
            setOnClickListener {
              promise?.resolve(index)
              popupWindow?.dismiss()
            }
          }
          val size = configDefaults.checkIconSize
          val itemView = TextView(reactApplicationContext).apply {
            text = title
            layoutParams = FlexboxLayout.LayoutParams(
             LayoutParams.WRAP_CONTENT,
              LayoutParams.WRAP_CONTENT
            ).apply {
              if (selectIndex == index) {
                setTextColor(configDefaults.selectedTextColor.toColorInt())
                rightMargin=4.dpToPx(context)
              } else {
                setTextColor(configDefaults.textColor.toColorInt())
                rightMargin=(size+4).dpToPx(context)
              }
            }
            (layoutParams as? FlexboxLayout.LayoutParams)?.flexGrow = 1f

            setTextSize(TypedValue.COMPLEX_UNIT_SP, configDefaults.textFont.fontSize)
            setTypeface(typeface, Typeface.NORMAL)
            // 设置字体粗细
            typeface = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
              Typeface.create(Typeface.DEFAULT, configDefaults.textFont.fontWeight, false)
            } else {
              Typeface.create(Typeface.DEFAULT, configDefaults.textFont.fontWeight)
            }
            // 设置文本对齐方式
            gravity = when (configDefaults.textAlignment) {
              "center" -> Gravity.CENTER
              "right" -> Gravity.END
              else -> Gravity.START
            }
          }

          container.addView(itemView)
          if(index==selectIndex){
            val iconView = ImageView(reactApplicationContext).apply {
              layoutParams = FlexboxLayout.LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
              )
              (layoutParams as? FlexboxLayout.LayoutParams)?.flexShrink = 0f
              val icon = loadSvgFromAssets(context, "icon/check.svg", size.dpToPx(context), size.dpToPx(context))
              setImageDrawable(icon)
            }
            container.addView(iconView)
          }
          popupLayout.addView(container)
      }
        popupWindow = PopupWindow(
          popupLayout,
          configDefaults.menuWidth.dpToPx(reactApplicationContext),
          WindowManager.LayoutParams.WRAP_CONTENT,
          true
        ).apply {
          elevation = configDefaults.shadowRadius
          isOutsideTouchable = true
          isFocusable = true
        }
        anchorView.post {
          popupWindow!!.showAsDropDown(anchorView,0,5.dpToPx(reactApplicationContext))
        }
    }
  }}
  companion object {
    const val NAME = "Popover"
  }
}
