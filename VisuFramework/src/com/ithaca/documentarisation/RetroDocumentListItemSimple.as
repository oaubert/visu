package com.ithaca.documentarisation
{
import com.ithaca.documentarisation.events.RetroDocumentEvent;
import com.ithaca.utils.components.IconButton;
import com.ithaca.utils.components.IconInfoSegment;
import com.ithaca.visu.model.vo.RetroDocumentVO;
import com.ithaca.visu.ui.utils.IconEnum;

import flash.events.MouseEvent;

import gnu.as3.gettext.FxGettext;
import gnu.as3.gettext._FxGettext;

import mx.controls.Alert;
import mx.controls.Menu;
import mx.controls.PopUpButton;
import mx.events.CloseEvent;
import mx.events.MenuEvent;

import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class RetroDocumentListItemSimple extends SkinnableComponent
{
	[SkinPart("true")]
	public var labelRetroDocument:Label;
	[SkinPart("true")]
	public var iconInfoVideo:IconInfoSegment;
	[SkinPart("true")]
	public var iconInfoAudio:IconInfoSegment;
	[SkinPart("true")]
	public var buttonDelete:IconButton;
	[SkinPart("true")]
	public var buttonShare:IconButton;
	
	private var _retroDocumentVO:RetroDocumentVO;
	private var retroDocumentVOChange:Boolean;
	
	private var menuAction:Menu;
	
	private var nbrAudioSegment:int;
	private var nbrVideoSegment:int;
	
	private var over:Boolean;
	
	[Bindable]
	private var fxgt:_FxGettext;
	
	public function RetroDocumentListItemSimple()
	{
		super();
		fxgt = FxGettext;
	}
	
	//_____________________________________________________________________
	//
	// Setter/getter
	//
	//_____________________________________________________________________
	public function set retroDocumentVO(value:RetroDocumentVO):void
	{
		_retroDocumentVO = value;
		parseRetroDocument();
		retroDocumentVOChange = true;
	}
	public function get retroDocumentVO():RetroDocumentVO
	{
		return _retroDocumentVO;
	}
	public function rendererNormal():void
	{
		over = false;
		invalidateSkinState();
	}
	public function rendererOver():void
	{
		over = true;
		invalidateSkinState();
	}
	
	//_____________________________________________________________________
	//
	// Overriden Methods
	//
	//_____________________________________________________________________
	
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName,instance);
		if (instance == labelRetroDocument)
		{
			if(retroDocumentVO)
			{
				labelRetroDocument.text = retroDocumentVO.title;
			}
		}
		if (instance == iconInfoVideo)
		{
			var iconInfoVideoVisible:Boolean = true;
			if(nbrVideoSegment == 0)
			{
				iconInfoVideoVisible = false;
			}
			iconInfoVideo.visible = iconInfoVideoVisible;
			iconInfoVideo.nbrElement = nbrVideoSegment;
			iconInfoVideo.sourceIcon = IconEnum.getIconByName('iconVideo_16x16');
			
		}
		if (instance == iconInfoAudio)
		{
			var iconInfoAudioVisible:Boolean = true;
			if(nbrAudioSegment == 0)
			{
				iconInfoAudioVisible = false;
			}
			iconInfoAudio.visible = iconInfoAudioVisible;
			iconInfoAudio.nbrElement = nbrAudioSegment;
			iconInfoAudio.sourceIcon = IconEnum.getIconByName('iconAudio_16x16');
		}
		if (instance == buttonDelete)
		{
			buttonDelete.addEventListener(MouseEvent.CLICK, onClickButtonDelete);
			buttonDelete.icon =  IconEnum.getIconByName('delete');
			buttonDelete.toolTip = "Supprimer ce bilan";
		}
		if (instance == buttonShare)
		{
			buttonShare.addEventListener(MouseEvent.CLICK, onClickButtonShare);
			buttonShare.icon =  IconEnum.getIconByName('retroDocumentShared');
			buttonShare.toolTip = "Partager ce bilan";
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName,instance);
		
	}
	override protected function commitProperties():void
	{
		super.commitProperties();	
		if(retroDocumentVOChange)
		{
			retroDocumentVOChange = false;
			
			if(labelRetroDocument)
			{
				labelRetroDocument.text = retroDocumentVO.title;
			}
			if(iconInfoVideo)
			{
				var iconInfoVideoVisible:Boolean = true;
				if(nbrVideoSegment == 0)
				{
					iconInfoVideoVisible = false;
				}
				iconInfoVideo.visible = iconInfoVideoVisible;
				iconInfoVideo.nbrElement = nbrVideoSegment;
			}
			if(iconInfoAudio)
			{			
				var iconInfoAudioVisible:Boolean = true;
				if(nbrAudioSegment == 0)
				{
					iconInfoAudioVisible = false;
				}
				iconInfoAudio.visible = iconInfoAudioVisible;
				iconInfoAudio.nbrElement = nbrAudioSegment;
			}
			
		}	
	}
	override protected function getCurrentSkinState():String
	{
		var skinName:String;
		if(!enabled)
		{
			skinName = "disable";
		}else if(over)
		{
			skinName = "over";
		}else
		{
			skinName = "normal"
		}
		return skinName;
	}
	//_____________________________________________________________________
	//
	// Listeners
	//
	//_____________________________________________________________________

	private function onClickButtonDelete(event:MouseEvent):void
	{
		Alert.yesLabel = fxgt.gettext("Oui");
		Alert.noLabel = fxgt.gettext("Non");
		Alert.show(fxgt.gettext("Êtes-vous sûr de vouloir supprimer le bilan intitulé "+'"'+retroDocumentVO.title+'"'+" ?"),
			fxgt.gettext("Confirmation"), Alert.YES|Alert.NO, null, removeRetroDocumentConformed); 
	}
	private function onClickButtonShare(event:MouseEvent):void
	{
		var loadListUsers:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.LOAD_LIST_USERS);
		this.dispatchEvent(loadListUsers);
	}
	// remove retroDocument
	private function removeRetroDocumentConformed(event:CloseEvent):void
	{
		if( event.detail == Alert.YES)
		{
			var removeRetroDocumentEvent:RetroDocumentEvent = new RetroDocumentEvent(RetroDocumentEvent.DELETE_RETRO_DOCUMENT);
			removeRetroDocumentEvent.idRetroDocument = retroDocumentVO.documentId;
			removeRetroDocumentEvent.sessionId = retroDocumentVO.sessionId;
			this.dispatchEvent(removeRetroDocumentEvent);
		}
	}
	//_____________________________________________________________________
	//
	// Utils
	//
	//_____________________________________________________________________
	
	private function parseRetroDocument():void
	{
		nbrAudioSegment = 0;
		nbrVideoSegment = 0;
		var xml:XML = new XML(_retroDocumentVO.xml);
		var listNodeTypeSource:XMLList = xml.child(RetroDocumentConst.TAG_SEGMENT);
		var nbrNodeSegment:int = listNodeTypeSource.length();
		for(var nNodeSegment:int = 0; nNodeSegment < nbrNodeSegment; nNodeSegment++)
		{
			var nodeTypeSource:XML = listNodeTypeSource[nNodeSegment] as XML;
			var typeNodeSegment:String =  nodeTypeSource.child(RetroDocumentConst.TAG_TYPE_SOURCE).toString();
			switch (typeNodeSegment)
			{
				case RetroDocumentConst.VIDEO_SEGMENT :
					nbrVideoSegment ++;
					break;
				case RetroDocumentConst.COMMENT_AUDIO_SEGMENT :
					nbrAudioSegment ++;
					break;
			}
		}
		
		invalidateProperties();
	}
	
	
}
}