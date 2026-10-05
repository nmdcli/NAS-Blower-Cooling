// ==========================================================
// NAS 双 5010 涡轮风扇 T 型刚性固定支架 (最新实测定稿版)
// 适配: TANK米多贝克 6盘位NAS机箱 + MATX All-in-One + 4热管被动散热器改装
// 坐标定义: X+ 向右(直吹散热鳍片), Y+ 向后(机箱尾部), Z+ 向下(机箱底板)
// ==========================================================

$fn = 50;

// ------------ 关键尺寸参数 (单位: mm) ------------
// 1. 机箱空间与主立板基础尺寸
total_height        = 163.0;    // 机箱顶梁接触面到机箱金属底板总高 (Z: 0 -> 163)
main_plate_th       = 7.8;      // 主固定立板厚度 (X: 0 -> 7.8, 由9.8mm缩减2.0mm，消除机箱滑入装配干涉)

// 2. 螺栓孔参数 (适配梁上原装孔位与 M2.6 自攻螺丝)
h1_y                = 5.20;     // H1 中心距前方阻挡物(硬盘笼端面)基准距离
hole_pitch          = 74.78;    // 两螺栓孔中心距 (实测精确值)
h2_y                = h1_y + hole_pitch; // 79.98mm
hole_dia            = 2.2;      // 适配 M2.6 自攻螺丝底孔 (梁上孔径实测 2.71/2.74mm)
hole_x_offset       = 3.9;      // 螺孔居中于主板厚度 (7.8 / 2 = 3.9mm)
screw_depth         = 15.0;     // 垂直向下钻孔深度 (盲孔设计，无需穿透)
main_plate_len      = h2_y + (hole_dia / 2) + 10.0; // 91.08mm (H2孔后保留10mm肉厚)

// 3. 5010 涡轮风扇实测参数 (单颗)
fan_w               = 50.0;     // 风扇正面宽度 (X 方向，实测 50.01mm)
fan_h               = 50.1;     // 单个风扇高度 (Z 方向，双扇堆叠实测 100.18mm)
fan_th              = 10.8;     // 风扇机身厚度 (Y 方向，实测 10.80mm)
fan_outlet_h        = 40.9;     // 单扇出风口垂直有效高度 (实测 40.9mm)
fan_outlet_top_gap  = 1.7;      // 出风口上边缘距机壳外沿厚度

// 4. Y 轴对中定位 (进风面距阻挡物 32mm，喷嘴居中对准散热鳍片核心区)
fan_front_y         = 32.0;     // 进风面距前方阻挡物 32.0mm
fit_tol             = 0.4;      // 减震泡棉微过盈装配公差
back_plate_th       = 4.5;      // 风扇后背支撑立板厚度 (Y 方向)
fan_back_plate_y    = fan_front_y + fan_th + fit_tol; // 约 43.2mm

// 5. Z 轴垂直定位与风扇仓尺寸微调 (高宽各扩容 1.5mm，限位减薄 1.0mm，总净空各增 2.5mm)
fan_holder_w        = 51.5;     // 向右伸出宽度 (X: 由 50.0mm 增至 51.5mm)
fan_holder_h        = 104.5;    // 容纳双风扇垂直堆叠总高 (Z: 由 103.0mm 增至 104.5mm)
fan_z_top           = 0.0;      // 挂板顶端对齐顶梁接触面 (Z = 0)
fan_z_bottom        = fan_z_top + fan_holder_h; // Z = 104.5mm，下方保留近 60mm 避开排气扇

// 6. 穿线孔与共面全贯通导线系统参数
plug_hole_w         = 12.0;     // 4-Pin 插头穿线孔长 (X 方向)
plug_hole_h         = 7.0;      // 4-Pin 插头穿线孔高 (Z 方向)
groove_depth        = 2.0;      // 全局导线槽深度 (深 2.0mm，匹配 2.02mm 线宽)
groove_width        = 4.0;      // 全局导线槽宽度 (宽 4.0mm)
side_groove_len     = 13.0;     // 主板内侧贴靠导线槽长度 (Y 方向)

module fan_bracket_v8_final() {
    difference() {
        // ----------------- 实体构建 (Union) -----------------
        union() {
            // 1. 主固定立板 (贴梁下挂触底，Z: 0 -> 163mm，板厚 7.8mm)
            translate([0, 0, 0])
                cube([main_plate_th, main_plate_len, total_height]);

            // 2. T 型向右伸出的风扇承载挂板 (位于风扇后侧，Z: 0 -> 104.5mm)
            translate([main_plate_th, fan_back_plate_y, fan_z_top])
                cube([fan_holder_w, back_plate_th, fan_holder_h]);

            // 3. 风扇仓顶部限位挡板 (厚度减薄至 2.0mm，增加垂直容差)
            translate([main_plate_th, fan_front_y, fan_z_top])
                cube([fan_holder_w, fan_th + fit_tol, 2.0]);

            // 4. 风扇仓底部承托板 (厚度 3.0mm，Z = 104.5mm)
            translate([main_plate_th, fan_front_y, fan_z_bottom - 3.0])
                cube([fan_holder_w, fan_th + fit_tol, 3.0]);

            // 5. 风扇右侧限位立壁 (厚度减薄至 1.5mm，增加水平容差)
            translate([main_plate_th + fan_holder_w - 1.5, fan_front_y, fan_z_top])
                cube([1.5, fan_th + fit_tol, fan_holder_h]);

            // 6. 下方三角加强筋支撑 (完全实心闭合结构，提升抗振刚度与打印层间强度)
            translate([main_plate_th, fan_back_plate_y, fan_z_bottom])
                rotate([90, 0, 90])
                    linear_extrude(height = 10.0)
                        polygon(points = [[0, 0], [back_plate_th + fan_th, 0], [0, 42]]);
        }

        // ----------------- 扣减挖空 (Difference) -----------------

        // A. H1 螺栓孔 (垂直向下钻入盲孔，深度 15mm，孔径 2.2mm)
        translate([hole_x_offset, h1_y, -0.5])
            cylinder(d = hole_dia, h = screw_depth + 1);

        // B. H2 螺栓孔 (中心距 74.78mm，垂直向下钻入盲孔)
        translate([hole_x_offset, h2_y, -0.5])
            cylinder(d = hole_dia, h = screw_depth + 1);

        // C. 上层风扇出风口开槽 (右侧正对鳍片吹风，开孔高度 40.9mm)
        translate([
            main_plate_th + fan_holder_w - 4.0,
            fan_front_y - 1.0,
            fan_z_top + fan_outlet_top_gap
        ])
            cube([6.0, fan_th + fit_tol + 2.0, fan_outlet_h]);

        // D. 下层风扇出风口开槽 (右侧正对鳍片吹风，开孔高度 40.9mm)
        translate([
            main_plate_th + fan_holder_w - 4.0,
            fan_front_y - 1.0,
            fan_z_top + fan_h + fan_outlet_top_gap
        ])
            cube([6.0, fan_th + fit_tol + 2.0, fan_outlet_h]);

        // ----------------- 4-Pin 穿线孔 (完全紧靠主板根部) -----------------
        // E1. 上层风扇穿线孔 (起点 X = main_plate_th - 0.5，确保穿透交界面)
        translate([
            main_plate_th - 0.5,
            fan_back_plate_y - 1.0,
            fan_z_top + fan_h - plug_hole_h - 2.0
        ])
            cube([plug_hole_w + 0.5, back_plate_th + 2.0, plug_hole_h]);

        // E2. 下层风扇穿线孔 (起点 X = main_plate_th - 0.5)
        translate([
            main_plate_th - 0.5,
            fan_back_plate_y - 1.0,
            fan_z_bottom - plug_hole_h - 4.0
        ])
            cube([plug_hole_w + 0.5, back_plate_th + 2.0, plug_hole_h]);

        // ----------------- 主板内侧贴靠导线槽 -----------------
        // F1. 上风扇主板导线槽 (长 13mm，深 2mm，高 4mm，与穿线孔无缝贯通)
        translate([
            main_plate_th - groove_depth,
            fan_back_plate_y - side_groove_len,
            fan_z_top + fan_h - plug_hole_h - 2.0 + (plug_hole_h - groove_width) / 2
        ])
            cube([groove_depth + 1.0, side_groove_len + 1.0, groove_width]);

        // F2. 下风扇主板导线槽
        translate([
            main_plate_th - groove_depth,
            fan_back_plate_y - side_groove_len,
            fan_z_bottom - plug_hole_h - 4.0 + (plug_hole_h - groove_width) / 2
        ])
            cube([groove_depth + 1.0, side_groove_len + 1.0, groove_width]);

        // ----------------- 背面导线槽网络 (与内侧槽严格共面 X = main_plate_th - groove_depth) -----------------
        // G1. 上层背面横向导线槽 (彻底切平台阶壁，X 深度与内侧槽一致)
        translate([
            main_plate_th - groove_depth,
            fan_back_plate_y + back_plate_th - groove_depth,
            fan_z_top + fan_h - plug_hole_h - 2.0 + (plug_hole_h - groove_width) / 2
        ])
            cube([plug_hole_w + groove_depth, groove_depth + 1.0, groove_width]);

        // G2. 下层背面横向导线槽
        translate([
            main_plate_th - groove_depth,
            fan_back_plate_y + back_plate_th - groove_depth,
            fan_z_bottom - plug_hole_h - 4.0 + (plug_hole_h - groove_width) / 2
        ])
            cube([plug_hole_w + groove_depth, groove_depth + 1.0, groove_width]);

        // H. 垂直主走线槽 (深 2.0mm，宽 4.0mm，止步于 Z = 104.5mm 挂板下沿，保留三角筋完整)
        translate([
            main_plate_th - groove_depth,
            fan_back_plate_y + back_plate_th - groove_depth,
            fan_z_top
        ])
            cube([groove_width, groove_depth + 1.0, fan_holder_h]);
    }
}

// 渲染模型
fan_bracket_v8_final();
