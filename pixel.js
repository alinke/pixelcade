function changeControls(mode)
{
    switch(mode)
    {
        case "animations":
        {
            hideElement("stillPanel");
            hideElement("scrollingTextPanel");
            showElement("animationsPanel");
            //hideElement("clockPanel");
            //hideElement("arcadePanel");
            break;
        }
        case "still":
        {
            hideElement("animationsPanel");
            hideElement("scrollingTextPanel");
            showElement("stillPanel");
            //hideElement("clockPanel");
            //hideElement("arcadePanel"); 
            break;
        }
       // case "clock":
       // {
       //     hideElement("animationsPanel");
       //     hideElement("stillPanel");
       //     hideElement("scrollingTextPanel");
       //     hideElement("arcadePanel");
            
       //     showElement("clockPanel");
            
       //     break;
       // }

       // case "arcade":
       // {
       //     hideElement("animationsPanel");
       //     hideElement("stillPanel");
       //     hideElement("scrollingTextPanel");
       //     hideElement("clockPanel");

       //     showElement("arcadePanel");

       //     break;
       // }

        default:
        {
            // scrolling text
            hideElement("animationsPanel");
            hideElement("stillPanel");
            showElement("scrollingTextPanel");
            //hideElement("clockPanel");
            //hideElement("arcadePanel");
            break;
        }
    }
}

function changeScrollingText(text)
{
    var modeString = "text?t=" + text;
    
    modeChanged(modeString);
}

function changeScrollingTextSpeed(speed)
{
    var speedString = "text/speed/" + speed;
    
    modeChanged(speedString);
}

function changeScrollingTextColor(color)
{
    var hex = color.substring(1);
    var colorString = "text/color/" + hex;
    
    modeChanged(colorString);
}

function displayImage(imagePath, name)
{
    var mode;
    
    switch(imagePath)
    {
        case "animations/save/":
        {
            mode = "animations/write/";
            alert("Pixelcade Marquee will be blank until writing has completed, please don't select anything else until the animation appears on Pixelcade");
            break;
        }
        case "animations/":
        {
            mode = "animations/stream/";
            break;
        }
        
        case "images/save/":
        {
            mode = "still/save/";
            break;
        }
        
       // case "arcade/":
       // {
       //     mode = "arcade/";
       //     break;
       // }

        default:
        {
            // still images
            mode = "still/";
        }
    }
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        logServerResponse(xmlhttp);
    }
    var url = "/" + mode + name; 
    // alert(url); pop up for debugging
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");    
}

function getLastUpdateOrigin()
{
    
    
    
}

function hideElement(id)
{
    var element = document.getElementById(id);
    element.style.display = 'none';
}

function loadAnimations()
{
    var url = "/animations/list";
    var elementName = "animations";
    var imagePath = "animations/";
    
    loadImageList(url, elementName, imagePath);
}

//function loadArcade()
//{
//    var url = "/arcade/list";
//    var elementName = "arcade";
//    var imagePath = "arcade/";
//    
//    loadImageList(url, elementName, imagePath);
//}


function loadImageList(url, elementName, imagePath)
{
    logEvent("loading " + elementName + "...");
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200)      
        {
            var list = xmlhttp.responseText;
            
            var names = list.split("-+-");
            
            var html = "<div class='thumb-holder'>";
            
 //           var c = 0;
            var columns = 4;
            
            for(var n in names)
            {
                var name = names[n].trim();
                
                var mod = parseInt(n) % columns;
                if(mod == 0)
                {
                    html += "<tr>";
                }
                
                if(name != "")
                {
                    html += "<div class='thumb'>";
                    html += "<img src=\"/files/" + imagePath + name + "\" " + 
                                   "width=\"100\" height=\"50\" alt=\"" + name +  "\"" + ">";

                    html += "<p>" + name + "</p>";                    
                    html += "<center style=\"margin-bottom: 40px;\">";
                    html += "<button onclick=\"displayImage('" + imagePath + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Display</button>";
                    
                    if(imagePath == "images/")
                    {
                        html += " ";
                        html += "<button onclick=\"displayImage('" + imagePath + "save/" + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Save</button>";
                    }
                    
                    if(imagePath == "animations/")
                    {
                        html += " ";
                        html += "<button onclick=\"displayImage('" + imagePath + "save/" + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Save</button>";
                    }

                    // if(imagePath == "arcade/")
                    //{
                    //    html += " ";
                    //    html += "<button onclick=\"displayImage('" + imagePath + "', '" + name + "')\" style=\"margin-left: auto; margin-right: auto;\">Save</button>";
                    //}

                    html += "</center>";
                    html += "</div>";
                }
                
                if(mod == 0)
                {
                    html += "</tr>";
                }
            }
            
            html += "<div class=\"spacer\">&nbsp;</div>";
            
            html += "</div>";
            
            var e = document.getElementById(elementName);
            e.innerHTML = html;
            
            logEvent("done loading " + elementName);
        }
    }
    
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");    
}

function loadImageResources()
{
    loadStillImages();
    //loadArcade();
    loadAnimations(); //this works
}

function loadStillImages()
{
    var url = "/still/list";
    var elementName = "still";
    var imagePath = "images/";
    
    loadImageList(url, elementName, imagePath);
}

function logServerResponse(xmlhttp)
{
    if (xmlhttp.readyState==4 && xmlhttp.status==200)      
    {
        var s = xmlhttp.responseText;
        logEvent(s);
    }
}

function logEvent(message)
{
    var e = document.getElementById("logs");
    
    var logs = message + "<br/>" + e.innerHTML;
    
    e.innerHTML = logs;
}

function modeChanged(mode, imageName)
{
    if(imageName === null)
    {
        imageName = "";
    }
    
    changeControls(mode);
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        logServerResponse(xmlhttp);
    }
    var url = "/" + mode;
    
    if(imageName != "" && !(imageName === undefined))
    {
        url += "/" + imageName;
    }
    
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");
}

function showElement(id)
{
    var element = document.getElementById(id);
    element.style.display = 'block';
}

function updateMode()
{
//    alert("in updateMode()");
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        // display the correct mode UI
        var response = xmlhttp.responseText;
        
        var label = "Scrolling Text";
        
        var o = 2
        
        switch(response)
        {
            case "ANIMATED_GIF":
            {
                modeChanged("animations");

                label = "Animations";
                
                o =0;

                break;
            }
            case "STILL_IMAGE":
            {
                modeChanged("still");        
                
                label = "Still Images";

                o = 1;
                break;
            }
            default:
            {
                
                // scrolling text
                changeScrollingText('Pixelcade');

                break;
            }
        }
        
        document.getElementById('mode').selectedIndex = o;
        
        xmlhttp.responseText += " uploaded";
        
        logServerResponse(xmlhttp);
    }
    
    var url = "/upload/origin";
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send("&p=3");
    
}
