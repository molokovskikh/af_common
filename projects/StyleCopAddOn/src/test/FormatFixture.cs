using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StyleCop;
using StyleCop.CSharp;
using NUnit.Framework;

namespace test
{
	[TestFixture]
	public class FormatFixture
	{
		[Test]
		public void Using()
		{
			var code = @"using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RemotePriceProcessor;

namespace Inforoom.StatViewer
{
	public class DownPriceSaver
	{
		public static void SaveDownPrice(HistoryFile file, bool dontAsk = false)
		{
			var dialog = new SaveFileDialog {
				FileName = Path.GetFileName(file.Filename),
				Filter = String.Format(""{0}|*{0}"", Path.GetExtension(file.Filename))
			};
			if (dontAsk || dialog.ShowDialog() == DialogResult.OK) {
				using (var fileStream = file.FileStream)
				using (var historyFileStream = new FileStream(dialog.FileName, FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite)) {
					fileStream.CopyTo(historyFileStream);
				}
			}
		}
	}
}";
			Run(code);
		}

		[Test]
		public void Using_fail()
		{
			var code = @"using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using RemotePriceProcessor;

namespace Inforoom.StatViewer
{
	public class DownPriceSaver
	{
		public static void SaveDownPrice(HistoryFile file, bool dontAsk = false)
		{
			var dialog = new SaveFileDialog {
				FileName = Path.GetFileName(file.Filename),
				Filter = String.Format(""{0}|*{0}"", Path.GetExtension(file.Filename))
			};
			if (dontAsk || dialog.ShowDialog() == DialogResult.OK) {
				using (var fileStream = file.FileStream) {
				using (var historyFileStream = new FileStream(dialog.FileName, FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite)) {
					fileStream.CopyTo(historyFileStream);
				}
				}
			}
		}
	}
}";
			Run(code);
		}

		private static void Run(string code)
		{
			var filename = "1.cs";
			File.Delete(filename);
			File.WriteAllText(filename, code);
			var core = new StyleCopCore();
			core.Initialize(new[] { @"..\..\..\StyleCopAddOn\bin\debug\" }, true);
			var add = (dynamic)core.GetAnalyzer("StyleCopAddOn.StyleCopAddOn");
			core.ViolationEncountered += (sender, args) => { Console.WriteLine(args); };

			var parser = core.GetParser("StyleCop.CSharp.CsParser");

			CodeDocument doc = null;
			parser.ParseFile(new CodeFile(filename, new CodeProject(1, "", new Configuration(new string[0])), parser), 0, ref doc);
			add.AnalyzeDocument(doc);
		}

	}
}
