<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%--<link rel="stylesheet" href="${ctx}/css/blue/ht_style.css" type="text/css" >--%>
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/three.js" ></script>
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery-1.11.2.js" ></script>
    <title></title>
    <script type="text/javascript">
        $(document).ready(function() {
            // 新建场景--场景是所有物体的容器
            var scene = new THREE.Scene();

            // 新建透视相机--相机决定了场景中那个角度的景色会显示出来。相机就像人的眼睛一样，人站在不同位置，抬头或者低头都能够看到不同的景色。
            var camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);

            // 新建3D渲染器
            var renderer = new THREE.WebGLRenderer();

            // 获取窗口的高度与宽度(不包含工具条与滚动条)并赋值给渲染器-- 设置渲染器的大小为窗口的内宽度，也就是内容区的宽度
            renderer.setSize(window.innerWidth, window.innerHeight);

            // 将3D场景添加到body元素
            document.body.appendChild(renderer.domElement);

            // 创建多维几何数据集
            var geometry = new THREE.CubeGeometry(1,1,1);

            // 创建基本材料
            var material = new THREE.MeshBasicMaterial({color: 0x00ff00});
            var cube = new THREE.Mesh(geometry, material);
            scene.add(cube);
            camera.position.z = 5;

            // 实时渲染
            function render() {
                requestAnimationFrame(render);// 这个函数就是让浏览器去执行一次参数中的函数
                cube.rotation.x += 0.1;
                cube.rotation.y += 0.1;
                /**
                 * 渲染
                 * @Param scene 定义的场景
                 * @Param camera 定义的透视相机
                 * @Param renderTarget 渲染的目标，默认是渲染到前面定义的render变量中
                 * @Param forceClear 每次绘制之前都将画布的内容给清除，即使自动清除标志autoClear为false，也会清除。
                 */
                renderer.render(scene, camera);
            }
            render();
        });





    </script>

</head>
<body>

</body>
</html>
