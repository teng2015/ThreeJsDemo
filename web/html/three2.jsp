<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/three.js" ></script>
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery-1.11.2.js" ></script>
    <title>Insert title here</title>
    <style type="text/css">
        div#canvas-frame {
            border: none;
            cursor: pointer;
            width: 100%;
            height: 600px;
            background-color: #EEEEEE;
        }
    </style>
    <script type="text/javascript">
        var renderer;
        function initThree() {
            width = document.getElementById('canvas-frame').clientWidth;
            height = document.getElementById('canvas-frame').clientHeight;
            renderer = new THREE.WebGLRenderer({
                antialias : true
            });
            renderer.setSize(width, height);
            document.getElementById('canvas-frame').appendChild(renderer.domElement);
            renderer.setClearColorHex(0xFFFFFF, 1.0);
        }

        var camera;
        function initCamera() {
            camera = new THREE.PerspectiveCamera(45, width / height, 1, 10000);
            camera.position.x = 0;
            camera.position.y = 1000;
            camera.position.z = 0;
            camera.up.x = 0;
            camera.up.y = 0;
            camera.up.z = 1;
            camera.lookAt({
                x : 0,
                y : 0,
                z : 0
            });
        }

        var scene;
        function initScene() {
            scene = new THREE.Scene();
        }

        var light;
        function initLight() {
            light = new THREE.DirectionalLight(0xFF0000, 1.0, 0);
            light.position.set(100, 100, 200);
            scene.add(light);
        }

        // A begin
        var cube;
        function initObject() {
            // 声明一个几何体geometry--几何体里面有一个vertices变量，可以用来存放点。
            var geometry = new THREE.Geometry();
            /**
             * 定义一种线条的材质--接受一个集合作为参数
             * 顶点颜色vertexColors: THREE.VertexColors，就是线条的颜色会根据顶点来计算
             */
            var material = new THREE.LineBasicMaterial( { vertexColors: THREE.VertexColors } );
            var color1 = new THREE.Color( 0x444444 ), color2 = new THREE.Color( 0xFF0000 );

            // 线的材质可以由2点的颜色决定
            var p1 = new THREE.Vector3( -100, 0, 100 );
            var p2 = new THREE.Vector3(  100, 0, -100 );

            geometry.vertices.push(p1);
            geometry.vertices.push(p2);
            geometry.colors.push( color1, color2 );

            // 定义线条，使用THREE.Line类
            var line = new THREE.Line( geometry, material, THREE.LinePieces );
            scene.add(line);
        }
        // A end

        function threeStart() {
            initThree();
            initCamera();
            initScene();
            initLight();
            initObject();
            renderer.clear();
            renderer.render(scene, camera);
        }


        function testDemo() {
            // 如何定义点--x,y,z
            var point = new THREE.Vector3 (4, 8, 9);
        }
    </script>

</head>
<body onload="threeStart();">
    <div id="canvas-frame"></div>
</body>
</html>