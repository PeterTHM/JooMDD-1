package de.thm.icampus.ejsl.ressourceTransformator

import de.thm.icampus.ejsl.eJSL.EJSLModel
import de.thm.icampus.ejsl.eJSL.CMSExtension
import de.thm.icampus.ejsl.eJSL.Feature
import de.thm.icampus.ejsl.eJSL.DetailsPage
import de.thm.icampus.ejsl.eJSL.DetailPageField
import de.thm.icampus.ejsl.eJSL.SimpleHTMLTypes
import de.thm.icampus.ejsl.eJSL.Attribute
import de.thm.icampus.ejsl.eJSL.DatatypeReference
import de.thm.icampus.ejsl.eJSL.EJSLFactory
import de.thm.icampus.ejsl.eJSL.SimpleHTMLTypeKinds
import de.thm.icampus.ejsl.eJSL.StandardTypes

class RessourceTransformer {
	EJSLModel modelInstance
	CMSExtension cmsextension
	Feature featurs
	new (EJSLModel model){
		modelInstance = model
		
		cmsextension = model.ejslPart as CMSExtension
		featurs = cmsextension.feature
		
	}
	def dotransformation(){
		transformEmptyHtmlAttribute();
		var JoomlaTranformator jt = new JoomlaTranformator(modelInstance)
		jt.completeCMSExtension
		
	}
	def transformEmptyHtmlAttribute(){
		
		for(DetailsPage dp: featurs.pages.filter(DetailsPage)){
			for(DetailPageField field: dp.editfields){
				if(field.htmltype == null){
				   field.htmltype = parseAttributeType(field.attribute)
				}
			}
		}
	}
	
	def SimpleHTMLTypes parseAttributeType(Attribute attribute) {
		switch attribute{
			DatatypeReference :{
				var SimpleHTMLTypes result = EJSLFactory.eINSTANCE.createSimpleHTMLTypes
				result.htmltype = SimpleHTMLTypeKinds.get("Text_Field")
				return result
			}
			StandardTypes:{
				var StandardTypes temptyp = attribute as StandardTypes
				var SimpleHTMLTypes result = EJSLFactory.eINSTANCE.createSimpleHTMLTypes
				result.htmltype = SimpleHTMLTypeKinds.get(parsingType(temptyp))
				return result
			}
		}
	}
	
	def String parsingType(StandardTypes eJSlType) {
		
		    var String value = "";
		switch (eJSlType.type.getName()){
			case "Integer" :{
				value = "Integer"
			}
			case "Boolean" :{
			value = "Yes_No_Buttons"
				
			}
			case "Textarea" :{
				value = "Textarea"
			}
			case "Textfield" :{
				value = "Text_Field"
			} 
			case "Time":{
				value = "Datepicker"
			}
			case "Date":{
				value = "Datepicker"
			}
			case "Datetime" :{
				value = "Datepicker"
				}
			case "Link" :{
				value = "Text_Field"
			}
			case "Image":{
				value = "Imagepicker"
			}
			case "File" :{
				value = "Filepicker"
			}
			case "Label":{
				value = "Text_Field_NE"
			}
			
		}

		return value
	}
	
}