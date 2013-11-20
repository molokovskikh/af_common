using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StyleCop;
using StyleCop.CSharp;
using System.Windows.Forms;

namespace StyleCopAddOn
{
	[SourceAnalyzer(typeof(CsParser))]
	public class StyleCopAddOn : SourceAnalyzer
	{
		private const int _tabSpaces = 1;

		public override void AnalyzeDocument(CodeDocument document)
		{
			var csharpDocument = (CsDocument)document;
			if (csharpDocument.RootElement != null && !csharpDocument.RootElement.Generated) {
				csharpDocument.WalkDocument(VisitElement, VisitStatement, VisitExpression);
			}

			base.AnalyzeDocument(document);
		}

		private bool CheckPreviousTokens(CsElement parentElement, Expression expression, int lastRow, int curentPosition)
		{
			return expression.Tokens.Count(t => t.Location.StartPoint.LineNumber > expression.LineNumber
				&& t.Location.StartPoint.LineNumber < lastRow
				&& GetMinIndex(parentElement, t.Location.StartPoint.LineNumber) == curentPosition - 1) > 0;
		}

		private void ExpressionWalk(Expression expression, CsElement parentElement)
		{
			foreach (var child in expression.ChildExpressions) {
				if (child.Tokens.Count(t => t.CsTokenType == CsTokenType.String
					&& t.Location.StartPoint.LineNumber != t.Location.EndPoint.LineNumber) == 0 &&
					expression.Tokens.Count(t => t.CsTokenType == CsTokenType.String
						&& t.Location.StartPoint.LineNumber != t.Location.EndPoint.LineNumber) == 0) {
					if (child.LineNumber != expression.LineNumber) {
						var minIndex = parentElement.Tokens.Where(e => e.LineNumber == child.LineNumber
							&& e.CsTokenType != CsTokenType.WhiteSpace).Min(t => t.Location.StartPoint.IndexOnLine);
						if (parentElement.Tokens.FirstOrDefault(t => t.LineNumber == child.LineNumber
							&& t.Location.StartPoint.IndexOnLine == GetMinIndex(parentElement, child.LineNumber))
							.CsTokenType != CsTokenType.CloseCurlyBracket)
							if (minIndex - GetMinIndex(parentElement, expression.LineNumber) != _tabSpaces) {
								var tok = expression.Tokens.FirstOrDefault(t => t.Location.StartPoint.LineNumber == child.LineNumber);
								if (expression.ExpressionType == ExpressionType.MethodInvocation)
									if (CheckPreviousTokens(parentElement, expression, child.LineNumber, GetMinIndex(parentElement, child.LineNumber)))
										continue;
								this.AddViolation(parentElement, child.LineNumber, "MoreOrLessThenOneTabToRightPosition");
								continue;
							}
					}
					ExpressionWalk(child, parentElement);
				}
			}
		}

		private void StatementWalk(Statement statement, CsElement parentElement)
		{
			foreach (var child in statement.ChildStatements) {
				if (child.LineNumber != statement.LineNumber && child.StatementType != StatementType.Block) {
					if (GetMinIndex(parentElement, child.LineNumber) - GetMinIndex(parentElement, statement.LineNumber) != _tabSpaces && statement.StatementType != StatementType.Block) {
						if (child.StatementType == StatementType.Using && statement.StatementType == StatementType.Using) {
							if (IsInBraces(statement))
							this.AddViolation(parentElement, child.LineNumber, "MoreOrLessThenOneTabToRightPosition");
						}
						else {
							this.AddViolation(parentElement, child.LineNumber, "MoreOrLessThenOneTabToRightPosition");
						}
						return;
					}

					if (GetMinIndex(parentElement, child.LineNumber) - GetMinIndex(parentElement, statement.Parent.LineNumber) != _tabSpaces && statement.StatementType == StatementType.Block) {
						this.AddViolation(parentElement, child.LineNumber, "MoreOrLessThenOneTabToRightPosition");
						return;
					}
				}
				StatementWalk(child, parentElement);
			}
		}

		private bool IsInBraces(Statement statement)
		{
			var tokens = statement.Tokens.Where(t => t.Parent == statement
				&& t.CsTokenType != CsTokenType.EndOfLine
				&& t.CsTokenType != CsTokenType.WhiteSpace).ToArray();
			if (tokens.Length < 2)
				return false;
			return tokens[tokens.Length - 2].CsTokenType == CsTokenType.OpenCurlyBracket
				&& tokens[tokens.Length - 1].CsTokenType == CsTokenType.CloseCurlyBracket;
		}

		private bool VisitExpression(Expression expression, Expression parentExpression, Statement parentStatement, CsElement parentElement, object context)
		{
			if (parentExpression == null) {
				if (parentStatement != null) {
					if (parentElement.Tokens.FirstOrDefault(t => t.LineNumber == expression.LineNumber && t.CsTokenType != CsTokenType.WhiteSpace
						&& t.Location.StartPoint.IndexOnLine == GetMinIndex(parentElement, expression.LineNumber)).CsTokenType != CsTokenType.CloseCurlyBracket)
						if (parentStatement.LineNumber != expression.LineNumber &&
							GetMinIndex(parentElement, expression.LineNumber) - GetMinIndex(parentElement, parentStatement.LineNumber) != _tabSpaces) {
							if (parentStatement.StatementType != StatementType.DoWhile) {
								this.AddViolation(parentElement, expression.LineNumber, "MoreOrLessThenOneTabToRightPosition");
							}
							else {
								if (parentStatement.Location.EndPoint.LineNumber != expression.LineNumber &&
									GetMinIndex(parentElement, expression.LineNumber) - GetMinIndex(parentElement, parentStatement.LineNumber) != _tabSpaces) {
									this.AddViolation(parentElement, expression.LineNumber, "MoreOrLessThenOneTabToRightPosition");
								}
							}
							return true;
						}
				}
				ExpressionWalk(expression, parentElement);
			}
			var curly = expression.Tokens.LastOrDefault(t => t.CsTokenType == CsTokenType.CloseCurlyBracket);
			if (curly != null && curly.Location.StartPoint.IndexOnLine != GetMinIndex(parentElement, expression.LineNumber) && curly.Location.StartPoint.IndexOnLine != GetMinIndex(parentElement, expression.Parent.LineNumber)
				&& curly.LineNumber != expression.LineNumber && curly.Parent.Equals(expression)) {
				this.AddViolation(parentElement, curly.LineNumber, "CloseCurlyBraketMustBeOnTheSameColumn");
			}
			curly = expression.Tokens.FirstOrDefault(t => t.CsTokenType == CsTokenType.OpenCurlyBracket);

			if (curly != null && curly.Parent.Parent == expression) {
				if (expression.LineNumber != curly.LineNumber && curly.Location.StartPoint.IndexOnLine == GetMinIndex(parentElement, curly.LineNumber)) {
					this.AddViolation(parentElement, curly.LineNumber, "OpenCurlyBraketOnTheSameLine");
				}
			}
			return true;
		}

		private bool VisitStatement(Statement statement, Expression parentExpression, Statement parentStatement, CsElement parentElement, object context)
		{
			if (parentStatement == null) {
				var minIndex = parentElement.Tokens.Where(e => e.LineNumber == statement.LineNumber
					&& e.CsTokenType != CsTokenType.WhiteSpace).Min(t => t.Location.StartPoint.IndexOnLine);
				if (parentElement.Tokens.FirstOrDefault(t => t.LineNumber == statement.LineNumber && t.CsTokenType != CsTokenType.WhiteSpace
					&& t.Location.StartPoint.IndexOnLine == GetMinIndex(parentElement, statement.LineNumber)).CsTokenType != CsTokenType.CloseCurlyBracket)

					if (statement.LineNumber != parentElement.LineNumber &&
						minIndex - GetMinIndex(parentElement, parentElement.LineNumber) != _tabSpaces) {
						this.AddViolation(parentElement, statement.LineNumber, "MoreOrLessThenOneTabToRightPosition");
						return true;
					}
				StatementWalk(statement, parentElement);
			}

			if ((parentStatement != null) &&
				(parentStatement.StatementType == StatementType.Else ||
				parentStatement.StatementType == StatementType.If) &&
				(statement.LineNumber == parentStatement.LineNumber) &&
				statement.StatementType != StatementType.Block) {
				this.AddViolation(parentElement, statement.LineNumber, "LogicalExpressionOnTheSameLine");
			}

			if (statement.StatementType == StatementType.Block) {
				if (parentStatement != null && parentStatement.StatementType == StatementType.Else && ((ElseStatement)parentStatement).ConditionExpression == null
					&& !statement.ChildStatements.Any(s => s.StatementType != StatementType.If && s.StatementType != StatementType.Else)) {
					if (statement.ChildStatements.Count(s => s.StatementType == StatementType.If) <= 1) {
						this.AddViolation(parentElement, statement.LineNumber, "ElseIfStatementMustBeWithoutBlock");
						return true;
					}
				}
				if (parentStatement != null && !parentStatement.Tokens.Any(t => t.LineNumber == statement.LineNumber &&
					t.CsTokenType != CsTokenType.WhiteSpace &&
					t.Location.StartPoint.IndexOnLine < statement.Location.StartPoint.IndexOnLine)) {
					this.AddViolation(parentElement, statement.LineNumber, "OpenCurlyBraketOnTheSameLine");
				}
			}
			return true;
		}

		private bool VisitElement(CsElement element, CsElement parentElement, object context)
		{
			if (parentElement != null && parentElement.ElementType != ElementType.Root) {
				if (parentElement.Tokens.FirstOrDefault(t => t.LineNumber == element.LineNumber && t.CsTokenType != CsTokenType.WhiteSpace).CsTokenType != CsTokenType.CloseCurlyBracket)
					if (element.Location.StartPoint.LineNumber != parentElement.Location.StartPoint.LineNumber &&
						GetMinIndex(parentElement, element.LineNumber) - GetMinIndex(parentElement.Parent as CsElement, parentElement.LineNumber) != _tabSpaces) {
						this.AddViolation(parentElement, element.LineNumber, "MoreOrLessThenOneTabToRightPosition");
					}
			}
			return true;
		}

		private int GetMinIndex(CsElement element, int lineNumber)
		{
			var res = element.Tokens.Where(e => e.LineNumber == lineNumber
				&& e.CsTokenType != CsTokenType.WhiteSpace).Min(t => t.Location.StartPoint.IndexOnLine);
			return res;
		}
	}
}
