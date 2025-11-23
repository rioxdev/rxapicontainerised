using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace rxapicontainerised.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DemoController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok("Hello from DemoController!");
        }
    }
}
